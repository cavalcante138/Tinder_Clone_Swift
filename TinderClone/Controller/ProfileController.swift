//
//  ProfileController.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 23/03/22.
//

import UIKit

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: AnyObject {
    func profileController(_ controller:  ProfileController, didLikeUser user: User)
    func profileController(_ controller:  ProfileController, didDislikeUser user: User)
}

class ProfileController: UIViewController{
    
    // MARK: - Proprieties
    
    private let user: User
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)
    private lazy var viewModel = ProfileViewModel(user: user)
    
    private lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = createButton()
        button.setImage(UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        return button
    }()
    
    private lazy var superlikeButton: UIButton = {
        let button = createButton()
        button.setImage(UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSuperlike), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton()
        button.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    

    
    // MARK: - Lyfecycle
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: User is \(user.name)")
        configureUI()
        loadUserData()
    }
    
    // MARK: - Actions
    
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDislike(){
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc func handleSuperlike(){
        
    }
    
    @objc func handleLike(){
        delegate?.profileController(self, didLikeUser: user)
    }
    
    // MARK: - Helpers
    
    func loadUserData(){
        infoLabel.attributedText = viewModel.userDetailsAttributeString
        professionLabel.text = viewModel.profession
        bioLabel.text = viewModel.bio
    }
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        
        configureBottomControls()
        configureBarStackView()
        
    }
    
    func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 56, paddingLeft: 8, paddingRight: 8, height: 4)
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
    func configureBottomControls(){
        
        let stack = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.spacing = -32
    
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        
    }
    
    func createButton() -> UIButton{
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
}


// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
