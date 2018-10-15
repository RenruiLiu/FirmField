//
//  CompaniesController+CreateCompany.swift
//  FirmField
//
//  Created by Renrui Liu on 15/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didEditCompany(company: Company) {
        guard let row = companies.firstIndex(of: company) else {return}
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        tableView.insertRows(at: [IndexPath(row: companies.count - 1, section: 0)], with: .automatic)
    }

}
