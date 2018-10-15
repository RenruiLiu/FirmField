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
        self.companies = CoreDataManager.shared.fetchCompanies()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func setupNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
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
            tableView.deleteRows(at: indexPathsToRemove, with: .automatic)
//            tableView.reloadData()
        } catch let err { print("Failed to delete objects from Coredata:", err) }
    }
    
    @objc fileprivate func handleAddCompany(){
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = UINavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
}



