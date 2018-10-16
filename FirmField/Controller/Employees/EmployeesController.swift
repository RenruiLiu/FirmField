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
    var employees = [Employee]()
    
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
        employees = companyEmployees
    }
    
    @objc private func handleAdd(){
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true)
    }
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.insertRows(at: [IndexPath(row: employees.count - 1, section: 0)], with: .automatic)
    }
}
