//
//  EmployeesController+UITableView.swift
//  FirmField
//
//  Created by Renrui Liu on 16/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

extension EmployeesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        let employee = employees[indexPath.row]
        if let birthday = employee.birthday {
            let birthdayDate = DateFormatter.myFormatter.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? "")     \(birthdayDate)"
        } else {
            cell.textLabel?.text = "\(employee.name ?? "")"
        }
        return cell
    }
}
