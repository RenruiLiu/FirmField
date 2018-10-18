//
//  CompaniesController+UITableView.swift
//  FirmField
//
//  Created by Renrui Liu on 15/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

extension CompaniesAutoUpdateController {
    
    //MARK:- TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeesController = EmployeesController()
        employeesController.company = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(employeesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
        cell.company = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    // header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lb = IndentedLabel()
        lb.text = fetchedResultsController.sectionIndexTitles[section]
        lb.backgroundColor = .lightBlue
        return lb
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
        return fetchedResultsController.sections?.count == 0 ? 150 : 0
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: handleDelete)
        deleteAction.backgroundColor = UIColor.lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: handleEdit)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction,editAction]
    }
    
    fileprivate func handleDelete(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = fetchedResultsController.object(at: indexPath)
        //        self.companies.remove(at: indexPath.row)
//        self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
        editCompanyController.company = fetchedResultsController.object(at: indexPath)
        let navController = UINavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
    }

}

