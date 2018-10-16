//
//  Extensions.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let tealColor = UIColor.rgb(red: 48, green: 164, blue: 182)
    static let lightRed = UIColor.rgb(red: 247, green: 66, blue: 82)
    static let darkBlue = UIColor.rgb(red: 9, green: 45, blue: 64)
    static let lightBlue = UIColor.rgb(red: 218, green: 235, blue: 243)
}

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true}
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true}
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true}
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true}
        if width != 0 {widthAnchor.constraint(equalToConstant: width).isActive = true}
        if height != 0 {heightAnchor.constraint(equalToConstant: height).isActive = true}
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIViewController {
    func setupPlusButnInNavBar(selector: Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "plus") , style: .plain, target: self, action: selector)
    }
    
    func setupCancelBtn(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat = 350) -> UIView{
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightBlue
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: height)
        return backgroundView
    }
}

extension DateFormatter {
    static let myFormatter = DateFormatter.getFormatter()
    
    static func getFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
}
