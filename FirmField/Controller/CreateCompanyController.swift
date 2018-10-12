//
//  CreateCompanyController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Company"

        setupNavigationBarItems()
    }
    
    fileprivate func setupNavigationBarItems() {
        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
}
