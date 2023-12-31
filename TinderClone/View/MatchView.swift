//
//  MatchView.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 24/03/22.
//

import UIKit

protocol MatchViewDelegate: AnyObject{
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User)
}

class MatchView: UIView{
    
    
    // MARK: - Proprieties
    
    private let viewModel: MatchViewViewModel
    
    weak var delegate: MatchViewDelegate?
    
    private let matchImageView: UIImageView = {
       
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "You and Sailor Moon have liked each others"
        return label
        
        
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane1.jpg"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let matchUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane1.jpg"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let sendMessageButton: UIButton = {
        let button = SendMessagesButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let keepSwippingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchUserImageView,
        sendMessageButton,
        keepSwippingButton
    ]
    
    
    // MARK: - Lifecycle
    
    
    init(viewModel: MatchViewViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        loadUserData()
        configureBlurView()
        configureUI()
        configureAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        // MARK: - Actions
    
    @objc func didTapSendMessage(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.delegate?.matchView(self, wantsToSendMessageTo: self.viewModel.matchedUser)
        }
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    
    
        
    // MARK: - Helpers
    
    func loadUserData(){
        descriptionLabel.text = viewModel.matchLabelText
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageUrl)
        matchUserImageView.sd_setImage(with: viewModel.matchedUserImageURl)
    }
    
    
    func configureUI(){
        views.forEach { view in
            addSubview(view)
            view.alpha = 0
        }
        
        currentUserImageView.anchor(right: centerXAnchor, paddingRight: 16 )
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        
        currentUserImageView.centerY(inView: self)
        
        matchUserImageView.anchor(left: centerXAnchor, paddingLeft: 16 )
        matchUserImageView.setDimensions(height: 140, width: 140)
        matchUserImageView.layer.cornerRadius = 140 / 2
        
        matchUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwippingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 48, paddingRight: 48)
        
        keepSwippingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
        
        
    }
    
    func configureAnimations(){
        views.forEach({ $0.alpha = 1 })
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        
        matchUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwippingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.45) {
                self.currentUserImageView.transform = .identity
                self.matchUserImageView.transform = .identity
            }
        }, completion: nil)

        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwippingButton.transform = .identity
        }, completion: nil)
    }
    
    func configureBlurView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }, completion: nil)

    }
    
}
