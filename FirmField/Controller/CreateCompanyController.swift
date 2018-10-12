//
//  CreateCompanyController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit
import CoreData

class CreateCompanyController: UIViewController {


    
    var delegate: CreateCompanyControllerDelegate?
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        return lb
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Company"

        setupNavigationBarItems()
        setupViews()
    }
    
    fileprivate func setupNavigationBarItems() {
        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func handleSave(){

        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        company.setValue(nameTextField.text, forKey: companyNameKey)
        
        do{
            try context.save() //this context will live when the conpaniesController presents
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let err { print("Failed to save company:",err) }
    }
    
    fileprivate func setupViews(){
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightBlue
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 100)
        
        backgroundView.addSubview(nameLabel)
        nameLabel.anchor(top: backgroundView.topAnchor, paddingTop: 16, bottom: nil, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, width: 100, height: 50)
        backgroundView.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nameLabel.rightAnchor, paddingLeft: 4, right: backgroundView.rightAnchor, paddingRight: 8, width: 0, height: 50)
    }
}
