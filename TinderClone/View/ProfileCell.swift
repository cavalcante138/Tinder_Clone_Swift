//
//  ProfileCell.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 23/03/22.
//

import UIKit


class ProfileCell: UICollectionViewCell{
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = #imageLiteral(resourceName: "lady5c.jpg")
        
        addSubview(imageView)
        imageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
