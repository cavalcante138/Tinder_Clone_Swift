//
//  AuthButton.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 18/03/22.
//

import UIKit

class AuthButton: UIButton{
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        layer.cornerRadius = 6
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error ocurred with the nscoder initiazer")
    }
    
    
}
