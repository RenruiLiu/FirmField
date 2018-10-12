//
//  ViewController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

class CompaniesController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupNavigationBarStyle()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    fileprivate func setupNavigationBarStyle() {
        navigationItem.title = "Companies"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 247, green: 66, blue: 82)
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    @objc fileprivate func handleAddCompany(){
        print("handleAddCompany")
    }

}

