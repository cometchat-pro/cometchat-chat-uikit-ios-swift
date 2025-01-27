//
//  SampleUserCVCell.swift
//  master-app
//
//  Created by Suryansh on 23/12/24.
//

import CometChatUIKitSwift
import UIKit

class SampleUserCVCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: CometChatAvatar = {
        let imageView = CometChatAvatar(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CometChatTypography.Body.medium
        label.textColor = CometChatTheme.textColorPrimary
        label.textAlignment = .center
        return label
    }()
    
    lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = CometChatTypography.Caption1.regular
        label.textColor = CometChatTheme.textColorSecondary
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.image = UIImage(systemName: "checkmark.square.fill")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMaxYCorner]
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        handleThemeModeChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(data: (name: String, uid: String, avatar: String)) {
        nameLabel.text = data.name
        uidLabel.text = data.uid
        imageView.setAvatar(avatarUrl: data.avatar, with: data.name)
    }
    
    func didSelect() {
        selectedImageView.isHidden = false
        containerView.layer.borderColor = CometChatTheme.borderColorHighlight.cgColor
    }
    
    func didDeselect() {
        selectedImageView.isHidden = true
        containerView.layer.borderColor = CometChatTheme.borderColorLight.cgColor
    }
        
    func buildUI() {
        
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = CometChatTheme.borderColorLight.cgColor
        containerView.layer.cornerRadius = 10
        
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerView.addSubview(uidLabel)
        NSLayoutConstraint.activate([
            uidLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            uidLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            uidLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        containerView.addSubview(selectedImageView)
        NSLayoutConstraint.activate([
            selectedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            selectedImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    open func handleThemeModeChange() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                self.containerView.layer.borderColor = CometChatTheme.borderColorLight.cgColor
            })
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Check if the user interface style has changed
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            self.containerView.layer.borderColor = CometChatTheme.borderColorLight.cgColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.reset()
    }
    
}
