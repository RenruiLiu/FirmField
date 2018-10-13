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

    var company: Company?{
        didSet{
            nameTextField.text = company?.name
            datePicker.date = company?.founded ?? Date()
        }
    }
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarItems()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
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
        if company == nil {
            createCompany()
        } else {
            saveEdit()
        }
    }
    
    fileprivate func createCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)

        // content to save
        company.setValue(nameTextField.text, forKey: companyNameKey)
        company.setValue(datePicker.date, forKey: companyFounedKey)
        
        do{
            try context.save() //this context will live when the conpaniesController presents
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let err { print("Failed to save company:",err) }
    }
    
    fileprivate func saveEdit(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // content to save
        company?.name = nameTextField.text
        company?.founded = datePicker.date

        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let err { print("Failed to edit company:",err) }
    }
    
    fileprivate func setupViews(){
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightBlue
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 250)
        
        backgroundView.addSubview(nameLabel)
        nameLabel.anchor(top: backgroundView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 8, right: nil, paddingRight: 0, width: 100, height: 50)
        backgroundView.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nameLabel.rightAnchor, paddingLeft: 4, right: backgroundView.rightAnchor, paddingRight: 8, width: 0, height: 50)
        backgroundView.addSubview(datePicker)
        datePicker.anchor(top: nameTextField.bottomAnchor, paddingTop: 0, bottom: backgroundView.bottomAnchor, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 0, right: backgroundView.rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
}
