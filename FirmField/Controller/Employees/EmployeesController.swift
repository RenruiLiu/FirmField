//
//  EmployeesController.swift
//  FirmField
//
//  Created by Renrui Liu on 16/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {

    let cellID = "cellID"
    var company : Company?
    
    var employees = [[Employee]]()
    let employeeTypes = [EmployeeType.executive.rawValue,EmployeeType.manager.rawValue,EmployeeType.staff.rawValue]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        tableView.backgroundColor = UIColor.darkBlue
        
        setupPlusButnInNavBar(selector: #selector(handleAdd))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    fileprivate func fetchEmployees(){
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        employees = []
        employeeTypes.forEach { (employeeType) in
            employees.append(
                companyEmployees.filter{$0.type == employeeType}
            )
        }
    }
    
    @objc private func handleAdd(){
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true)
    }
    
    func didAddEmployee(employee newEmployee: Employee) {
        guard let section = employeeTypes.firstIndex(of: newEmployee.type!) else {return}
        let insertionIndexPath = IndexPath(row: employees[section].count, section: section)
        employees[section].append(newEmployee)
        tableView.insertRows(at: [insertionIndexPath], with: .automatic)
    }
}
