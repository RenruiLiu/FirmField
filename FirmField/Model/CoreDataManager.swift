//
//  CoreDataManager.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    // a `singleton` will live forever as long as the app is still alive
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        // init core data stack from that datamodel file
        let container = NSPersistentContainer(name: datamodelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                print("Loading of store failed:",err)
            }
        })
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        // get firmModels context
        let context = persistentContainer.viewContext
        // get Company from Company Entity
        let fetchRequest = NSFetchRequest<Company>(entityName: companyKey)
        do {
            // get companies and reload to UI
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let err {
            print("Failed to fetch Companies :",err)
            return []
        }
    }
    
    func createEmployee(name: String, birthday: Date, company: Company) -> (Employee?,Error?){
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: employeeKey, into: context) as! Employee
        employee.company = company
        employee.birthday = birthday
        employee.name = name

        do{
            try context.save()
            return (employee, nil)
        } catch let err {
            return (nil,err)
        }
    }
}
