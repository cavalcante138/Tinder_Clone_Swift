//
//  CustomTextField.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 18/03/22.
//

import UIKit

class CustomTextField: UITextField{
    
    init(placeholder: String, isSecureField: Bool? = false, capitalizationType: UITextAutocapitalizationType? = .none){
        super.init(frame: .zero)
        
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        keyboardAppearance = .dark
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecureField!
        if let capitalization = capitalizationType {
            autocapitalizationType = capitalization
        }else{
            autocapitalizationType = .none
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("A error NSCoder")
    }
    
}
