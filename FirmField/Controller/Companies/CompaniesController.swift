//
//  ViewController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    let cellID = "cellID"
    
    var companies = [Company]()
    
    //MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Companies"

        setupTableView()
        setupNavigationBarItems()
        companies = CoreDataManager.shared.fetchCompanies()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setupNavigationBarItems() {
        setupPlusButnInNavBar(selector: #selector(handleAddCompany))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    }
    
    
    @objc fileprivate func handleReset(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do{
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated(){
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
        } catch let err { print("Failed to delete objects from Coredata:", err) }
    }
    
    @objc fileprivate func handleAddCompany(){
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = UINavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    
    func doNestedUpdates(){
        
        // 1. in background thread
        DispatchQueue.global(qos: .background).async {
            
            // 2.create a private context which is main context's child
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // 3. execute updates
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                // 3.1 fetch companies
                let companies = try privateContext.fetch(request)
                // 3.2 update companies
                companies.forEach({ (company) in
                    company.name = "D:\(company.name ?? "")"
                })
                
                // 4. save
                do{
                    // 4.1 save to main context
                    try privateContext.save()
                    
                    // 4.2 get back to main thread
                    DispatchQueue.main.async {
                        do {
                            // 4.3 save to persistent store
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            
                            // 4.4 reload UI
                            self.tableView.reloadData()
                        } catch let err {print("failed to save update to persistent store:",err)}
                    }
                } catch let err {print("failed to save update to main context:",err)}
            } catch let err {print("failed to fetch on private context:",err)}
        }
    }
}



