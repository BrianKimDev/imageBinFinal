//
//  CustomTextField.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//


import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, hiddenField: Bool? = false) {
        super.init(frame: .zero)
        
        // creating space for the textField
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        backgroundColor = UIColor(white:1, alpha: 0.3)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = hiddenField!
        keyboardAppearance = .dark
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
