//
//  CreateEmployeeController.swift
//  FirmField
//
//  Created by Renrui Liu on 16/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    var delegate: CreateEmployeeControllerDelegate?
    
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
    let birthdayLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        return lb
    }()
    let birthdayTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "MM/dd/yyyy"
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    fileprivate func setupUI(){
        navigationItem.title = "Create Employee"
        view.backgroundColor = .darkBlue
        setupCancelBtn()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    
        let backgroundView = setupLightBlueBackgroundView(height: 100)
        
        backgroundView.addSubview(nameLabel)
        nameLabel.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 100, height: 50)
        backgroundView.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nameLabel.rightAnchor, paddingLeft: 4, right: backgroundView.rightAnchor, paddingRight: 8, width: 0, height: 50)
        backgroundView.addSubview(birthdayLabel)
        birthdayLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 4, bottom: nil, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 100, height: 50)
        backgroundView.addSubview(birthdayTextField)
        birthdayTextField.anchor(top: birthdayLabel.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: birthdayLabel.rightAnchor, paddingLeft: 4, right: backgroundView.rightAnchor, paddingRight: 8, width: 0, height: 50)
    }
    
    @objc fileprivate func handleSave(){
        guard let employeeName = nameTextField.text else {return}
        guard let company = company else {return}
        guard let birthdayText = birthdayTextField.text else {return}
        
        // form validation
        
        
        // cast text into a Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            let alertController = UIAlertController(title: "Wrong Date", message: "Please enter a valid date", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        let (employee,err) = CoreDataManager.shared.createEmployee(name: employeeName, birthday: birthdayDate, company: company)
        if let err = err {
            print("Failed to save employee:",err)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: employee!)
            }
        }
    }
}
