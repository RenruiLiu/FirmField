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
        return employees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        let employee = employees[indexPath.section][indexPath.row]
        if let birthday = employee.birthday {
            let birthdayDate = DateFormatter.myFormatter.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? "")     \(birthdayDate)"
        } else {
            cell.textLabel?.text = "\(employee.name ?? "")"
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lb = IndentedLabel()
        lb.text = employeeTypes[section]
        lb.textColor = .darkBlue
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.backgroundColor = .lightBlue
        return lb
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}
