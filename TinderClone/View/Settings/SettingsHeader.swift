//
//  SettingsHeader.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 21/03/22.
//

import UIKit
import SDWebImage

protocol SettingsHeaderDelegate: AnyObject {
    func header(_ header: SettingsHeader, didselect index: Int)
}

class SettingsHeader: UIView{
    
    // MARK - Proprieties
    
    private let user: User
    var buttons = [UIButton]()
    weak var delegate: SettingsHeaderDelegate?
    
    lazy var button1 = createButton(0)
    lazy var  button2 = createButton(1)
    lazy var  button3 = createButton(2)
    
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .systemGray5
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        

        
        addSubview(button1)
        button1.anchor(top: topAnchor, left:  leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        loadUserPhotos()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleSelectPhoto(sender: UIButton){
        delegate?.header(self, didselect: sender.tag)
    }
    
    // MARK: - Helpers
    
    func loadUserPhotos(){
        
        let imageURLs = user.imageUrls.map({
            URL(string: $0)
        })
        
        for(index, url) in imageURLs.enumerated() {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) {(image, _, _, _, _, _) in
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                                                 
                                                 
            }
        }
    }
    
    
    
    func createButton(_ index: Int) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
        
    }
    

}
