//
//  ViewController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    let cellID = "cellID"
    
    var companies = [Company]()
    
    //MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Companies"

        setupTableView()
        setupNavigationBarItems()
        fetchCompanies()
    }
    
    fileprivate func setupNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc fileprivate func handleAddCompany(){
        let createCompanyController = CreateCompanyController()
        createCompanyController.delegate = self
        let navController = UINavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    fileprivate func fetchCompanies(){
        // get firmModels context
        let context = CoreDataManager.shared.persistentContainer.viewContext
        // get Company from Company Entity
        let fetchRequest = NSFetchRequest<Company>(entityName: entityName)
        do {
            // get companies and reload to UI
            companies = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let err { print("Failed to fetch Companies :",err) }
    }

    //MARK:- TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .tealColor
        
        let company = companies[indexPath.row]
        
        if let name = company.name, let foundedDate = company.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let founed = dateFormatter.string(from: foundedDate)
            cell.textLabel?.text = "\(name) - Founded: \(founed)"
        } else {
            cell.textLabel?.text = company.name
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: handleDelete)
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: handleEdit)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction,editAction]
    }
    
    // header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    fileprivate func handleDelete(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.deleteCompanyFromCoreData(company)
    }
    
    fileprivate func deleteCompanyFromCoreData(_ company: Company){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
        do{
            try context.save()
        } catch let saveErr { print("Failed to delete:", saveErr) }
    }
    
    fileprivate func handleEdit(action: UITableViewRowAction, indexPath: IndexPath){
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        editCompanyController.company = companies[indexPath.row]
        let navController = UINavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
    }
    
    func didEditCompany(company: Company) {
        guard let row = companies.firstIndex(of: company) else {return}
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        tableView.insertRows(at: [IndexPath(row: companies.count - 1, section: 0)], with: .automatic)
    }
}



