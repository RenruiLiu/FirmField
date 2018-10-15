//
//  CompanyCell.swift
//  FirmField
//
//  Created by Renrui Liu on 15/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet{
            if let name = company?.name, let foundedDate = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let founed = dateFormatter.string(from: foundedDate)
                nameFoundedLabel.text = "\(name) - Founded: \(founed)"
            } else {
                nameFoundedLabel.text = company?.name
            }
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    let companyImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 26
        iv.layer.borderColor = UIColor.darkBlue.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let nameFoundedLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textColor = .white
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor

        addSubview(companyImageView)
        addSubview(nameFoundedLabel)
        companyImageView.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 16, right: nil, paddingRight: 0, width: 52, height: 52)
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameFoundedLabel.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: companyImageView.rightAnchor, paddingLeft: 8, right: rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
