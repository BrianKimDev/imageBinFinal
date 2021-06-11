//
//  SettingsCell.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//


import UIKit

protocol SettingsCellDelegate: AnyObject {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateUserWith value: String,
                      for section: SettingsSection)
    
}

class SettingsCell: UITableViewCell {
    
    
    
    // MARK: - Properties
    
    
    
    weak var delegate: SettingsCellDelegate?
    
    
    var viewModel: SettingsViewModel! {
        didSet { configure() }
    }
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 28)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        
        return tf
    }()
    
    var sliderStack = UIStackView()
    
    
    
    
  
    // MARK: - Lifecycle
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGroupedBackground
        

        
        selectionStyle = .none
        
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleUpdateUserInfo(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCell(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    
    
   
    
    // MARK: - Helpers
    
    func configure() {
        
        inputField.placeholder = viewModel.placeHolderText
        inputField.text = viewModel.value
        
        
        

    }
    
}
