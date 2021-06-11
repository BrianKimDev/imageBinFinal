//
//  SettingsController.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit
import JGProgressHUD

private let reuseIdentifier = "SettingsCell"

protocol SettingsControllerDelegate: AnyObject {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWantsToLogOut(_ controller: SettingsController)
}

class SettingsController: UITableViewController {
    
    
    // MARK: - Properties
    
    private var user: User
    
    private lazy var headerView = SettingsHeader(user: user)
    private let footerView = SettingsFooter()
    private let imagePicker = UIImagePickerController()
    private var imageIndex = 0
    
    weak var  delegate: SettingsControllerDelegate?
    
    
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Actions
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Updating"
        hud.show(in: view)
        
        Service.saveUserData(user: user) { error in
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - API
    
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image..."
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imageURL in
            self.user.userUploads.append(imageURL)
            print("DEBUGGING: User image URLs \(self.user.userUploads)")
            hud.dismiss()
        }
    }
    
    
    // MARK: - Helpers
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
    }
    
    func configureUI() {
        headerView.delegate = self
        imagePicker.delegate = self
        
        
        navigationItem.title = "settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        
        
        
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none
        
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemBackground
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
        
    }
}
// MARK: - UITableViewDataSource


extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as!
            SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = .white
    }
    
    
    
}





// MARK: - UITableViewDelegate


extension SettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        print("DEBUG: Section is \(section)")
        guard let section = SettingsSection(rawValue: section) else { return nil }
        //        print("DEBUGGING: Section description is \(section.description) for value \(section.rawValue)")
        return section.description
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return 0}
        return section == .bio ? 94 : 65
        
    }
}


// MARK: - SettingsHeaderDelegate
extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true, completion: nil)
        //     print("selected button is \(index)")
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate


extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - SettingsCellDelegate

extension SettingsController: SettingsCellDelegate {
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String,
                      for section: SettingsSection) {
        switch section {
        case .socials:
            user.socials = value
        case .bio:
            user.bio = value
        case .discordID:
            user.discordId = value
            break
            
        }
    }
}

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.settingsControllerWantsToLogOut(self)
    }
    
    
}
