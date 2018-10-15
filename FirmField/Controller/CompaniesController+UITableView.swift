//
//  CompaniesController+UITableView.swift
//  FirmField
//
//  Created by Renrui Liu on 15/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    //MARK:- TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
        cell.company = companies[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
    // footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: handleDelete)
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: handleEdit)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction,editAction]
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

}
