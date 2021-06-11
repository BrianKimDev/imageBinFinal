//
//  ProfileController.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//


import Foundation
import UIKit

private let reuseIdentifier = "ProfileCell"

protocol profileControllerDelegate: AnyObject {
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)
}

class ProfileController: UIViewController {
    
    
    // MARK: - Properties
    
    
    
    private let user: User
    weak var delegate: profileControllerDelegate?
    
    private lazy var viewModel = ProfileViewModel(user: user)
    private lazy var barStackView = SegmentedBarView(numberOfSegments: viewModel.imageURLs.count)

    
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
        button.setImage(#imageLiteral(resourceName: "PROFILE").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view =  UIVisualEffectView(effect: blur)
        return view
        
    }()
    
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
         return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = ""
        return label
    }()
    
    
    private let discordIdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Brian#0001"
        return label
    }()
    
    
    private let socialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "aidmaodmasiodmosimdos"
        return label
    }()
    
    // MARK: - Bottom Controls
    
    private lazy var dislikeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "DISLIKE"))
        button.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.setDimensions(height: 45, width: 45)
        
        return button
    }()
    

    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "LIKE"))
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.setDimensions(height: 45, width: 45)
        return button
    }()
   
    
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadUserData()
        
    }
    
    
    // MARK: - Actions
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleDislike() {
        delegate?.profileController(self, didDislikeUser: user)
    }
    
   
    @objc func handleLike() {
        delegate?.profileController(self, didLikeUser: user)
        
    }
    
    
    
    
    
    // MARK: - Helpers
    
    func loadUserData() {
        infoLabel.attributedText = viewModel.userDetailsAttributedString
        discordIdLabel.text = viewModel.discordId
   
        
        bioLabel.text = viewModel.bio
    }
    
    func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        
        
        view.addSubview(collectionView)
        
        view.addSubview(dismissButton)
        dismissButton.setDimensions(height: 40, width: 40)
        /* set the top of the anchor of the button to the bottom of the collection view and moved it up by
         20 pixels, half of the button, so it appears in the middle
         */
        dismissButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel,socialLabel,discordIdLabel,bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 8
        
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor)
        
        configureBottomControls()
        configureBarStackView()
        
    }
    
    func configureBottomControls() {
        let stack = UIStackView(arrangedSubviews: [dislikeButton, likeButton])
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.spacing = -32
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 400)
        
         
    }
    func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: 35, paddingLeft: 8, paddingRight: 8, height: 4)
    
    }
    
    func createButton(withImage image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
}

// MARK: - UICollectionViewDataSource


extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for:
        indexPath) as! ProfileCell
        
        cell.imageView.sd_setImage(with: viewModel.imageURLs[indexPath.row])
        
        return cell
    }
    
    
    
}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView.setHighlighted(index: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

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
