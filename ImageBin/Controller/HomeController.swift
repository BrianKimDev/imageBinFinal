//
//  HomeController.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//


import UIKit
import Firebase

class HomeController : UIViewController {
    
    //MARK: - Properties
    
    private var user: User?
    
    private let topStack = HomeNavigationStackView()
    private let botStack = BottomControlsStackView()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    
    private var viewModels = [UserUploadViewModel]() {
        didSet { configureCards() }
    }
    
    
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        updateUI()
        fetchCurrentUserAndCards()
        
        
       // logout()
        
    }
    
    // MARK: - API
    
    
    func fetchUsers(forCurrentUser user: User) {
        Service.fetchUsers(forCurrentUser: user) { users in
            // taking users array and .map into an array of viewModels $0 = each user in the array
            self.viewModels = users.map({ UserUploadViewModel(user: $0) })
            
            
        }
    }
    
    func fetchCurrentUserAndCards() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.fetchUsers(forCurrentUser: user)
        }
        
        
        
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            showLoginController()
        } else {
            print("DEBUG: USER IS LOGGED IN")
        }
        
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            showLoginController()
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Service.saveSwipeForUser(forUser: user, isLike: didLike) { error in
            self.topCardView = self.cardViews.last
            
            guard didLike == true else { return }
            
            Service.checkIfMatchExists(forUser: user) { didMatch in
                self.presentMatchView(forUser: user)
            }
        }
    }
    
    
    // MARK: - Helpers
    
    
    func configureCards() {
        //        print("DEBUGGING: Reload user cards now..")
        viewModels .forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({ ($0 as? CardView)! })
        topCardView = cardViews.last
    }
    
    func updateUI() {
        configureGradientLayer()
        
        topStack.delegate = self
        botStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack,deckView,botStack])
        stack.axis = .vertical
        
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
        
    }
    
    func showLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.user else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700: -700
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations:  {
            self.topCardView?.frame = CGRect(x: translation, y: 0,
                                             width: (self.topCardView?.frame.width)!,
                                             height: (self.topCardView?.frame.height)!)
        }) { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else { return }
            // remove last from index and sets top cardView
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
        
        
    }
    
}

// MARK: - HomeNavigationStackViewDelegate
// conform to protocol
extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        guard let user = self.user else { return }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        // lol ios13
        present(nav, animated: true, completion: nil)
    }
    
    func showUploadImage() {
        let controller = UploadImageController()
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
}



//MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func settingsControllerWantsToLogOut(_ controller: SettingsController) {
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
}

// MARK: - CardViewDelegate

extension HomeController: CardViewDelegate {
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        
        self.cardViews.removeAll( where: { view == $0 })
        // check to see if views are equal to eachother want to remove all card views where this condition is met
        
        
        self.topCardView = cardViews.last
    }
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        
    }
}

//MARK: - BottomControlsStackViewDelegate

extension HomeController: BottomControlsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView else { return }
        
        
        performSwipeAnimation(shouldLike: true)
        saveSwipeAndCheckForMatch(forUser: topCard.viewModel.user, didLike: true)
        
        
        
        print("like user \(topCard.viewModel.user.name)")
    }
    
    func handleDislike() {
        guard let topCard = topCardView else { return }
        
        performSwipeAnimation(shouldLike: false)
        Service.saveSwipeForUser(forUser: topCard.viewModel.user, isLike: false, completion: nil)
    }
    
    func handleRefresh() {
        guard let user = self.user else { return }
        
        Service.fetchUsers(forCurrentUser: user) { users in
            self.viewModels = users.map({ UserUploadViewModel(user: $0) })
        }
    }
    
}

//MARK: - ProfileControllerDelegate

extension HomeController: profileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
            
        }
        
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            Service.saveSwipeForUser(forUser: user, isLike: false, completion: nil)
            
        }
        // wont perform the swipe animation until the dismissal animation has completed
        //print("dislike User here in profile")
        
    }
    
}

// MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
        
    }
}

extension HomeController: MatchViewDelegate {
    func matchView(_ view: MatchView, wantsToSendMessageToUser user: User) {
        print("start convo with \(user.name)")
    }
}

