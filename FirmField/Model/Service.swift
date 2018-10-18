//
//  Service.swift
//  FirmField
//
//  Created by Renrui Liu on 18/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    static let shared = Service()

    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer(){
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            
            if let err = err {
                print("Failed to download data:",err)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let jsonCompanies = try JSONDecoder().decode([JSONCompany].self, from: data)
                
                // do it in background
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsonCompany) in
                    // cast to Company
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    // date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    company.founded = dateFormatter.date(from: jsonCompany.founded)
                    
                    // employee
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        employee.birthday = dateFormatter.date(from: jsonEmployee.birthday)
                        employee.company = company
                    })
                    
                    // photo
                    guard let photoURL = URL(string: jsonCompany.photoUrl) else {return}
                    URLSession.shared.dataTask(with: photoURL) { (data, _, err) in
                        company.imageData = data
                        
                        do{
                            try privateContext.save()
                            try privateContext.parent?.save()
                        } catch let err {print(err)}
                        
                        }.resume()
                })
            } catch let err {print(err)}
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
    let photoUrl: String
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
