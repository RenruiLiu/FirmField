//
//  CreateCompanyController.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit
import CoreData

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var company: Company?{
        didSet{
            nameTextField.text = company?.name
            datePicker.date = company?.founded ?? Date()
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    lazy var companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorPhoto)))
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50
        iv.layer.borderColor = UIColor.darkBlue.cgColor
        iv.layer.borderWidth = 1
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
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
        setupCancelBtn()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
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
        
        let company = NSEntityDescription.insertNewObject(forEntityName: companyKey, into: context)

        // content to save
        company.setValue(nameTextField.text, forKey: companyNameKey)
        company.setValue(datePicker.date, forKey: companyFounedKey)
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: companyImageDataKey)
        }
        
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
        if let companyImage = companyImageView.image {
            company?.imageData = companyImage.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let err { print("Failed to edit company:",err) }
    }
    
    fileprivate func setupViews(){
        let backgroundView = setupLightBlueBackgroundView()
        
        backgroundView.addSubview(companyImageView)
        companyImageView.anchor(top: view.topAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 100, height: 100)
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backgroundView.addSubview(nameLabel)
        nameLabel.anchor(top: companyImageView.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 100, height: 50)
        backgroundView.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nameLabel.rightAnchor, paddingLeft: 4, right: backgroundView.rightAnchor, paddingRight: 8, width: 0, height: 50)
        
        backgroundView.addSubview(datePicker)
        datePicker.anchor(top: nameTextField.bottomAnchor, paddingTop: 0, bottom: backgroundView.bottomAnchor, paddingBottom: 0, left: backgroundView.leftAnchor, paddingLeft: 0, right: backgroundView.rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func handleSelectorPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
