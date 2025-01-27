//
//  ChangeAppCredentialsVC.swift
//  sample-app
//
//  Created by Suryansh on 25/12/24.
//

import UIKit
import CometChatUIKitSwift

class ChangeAppCredentialsVC: UIViewController {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cometchat-logo-with-name")?.withRenderingMode(.alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 134).isActive = true
        return imageView
    }()
    
    lazy var appCredentialsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "App Credentials"
        label.font = CometChatTypography.Heading2.bold
        label.textColor = CometChatTheme.textColorPrimary
        return label
    }()
    
    lazy var regionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Region"
        label.font = CometChatTypography.Body.medium
        label.textColor = CometChatTheme.textColorPrimary
        return label
    }()
    
    lazy var usRegionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onRegionSelected(_ :)), for: .primaryActionTriggered)
        button.setTitle("  US", for: .normal)
        button.titleLabel?.font = CometChatTypography.Button.medium
        button.setTitleColor(CometChatTheme.textColorSecondary, for: .normal)
        button.setImage(UIImage(named: "us-flag"), for: .normal)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        button.layer.cornerRadius = 8
        button.tag = 1
        return button
    }()
    
    lazy var indiaRegionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onRegionSelected(_ :)), for: .primaryActionTriggered)
        button.setTitle("  India", for: .normal)
        button.setImage(UIImage(named: "India-flag"), for: .normal)
        button.titleLabel?.font = CometChatTypography.Button.medium
        button.setTitleColor(CometChatTheme.textColorSecondary, for: .normal)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        button.layer.cornerRadius = 8
        button.tag = 2
        return button
    }()
    
    lazy var euRegionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onRegionSelected(_ :)), for: .primaryActionTriggered)
        button.setTitle("  EU", for: .normal)
        button.setImage(UIImage(named: "eu-flag"), for: .normal)
        button.titleLabel?.font = CometChatTypography.Button.medium
        button.setTitleColor(CometChatTheme.textColorSecondary, for: .normal)
        button.layer.borderWidth = 0.8
        button.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        button.layer.cornerRadius = 8
        button.tag = 3
        return button
    }()
    
    lazy var regionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.addArrangedSubview(usRegionButton)
        stackView.addArrangedSubview(indiaRegionButton)
        stackView.addArrangedSubview(euRegionButton)
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return stackView
    }()
    
    lazy var appIDTextFiled: CustomTextFiled = {
        let textFiled = CustomTextFiled(leadingText: "APP ID", placeholderText: "Enter the app ID")
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    lazy var authKeyTextField: CustomTextFiled = {
        let textFiled = CustomTextFiled(leadingText: "Auth Key", placeholderText: "Enter the auth key")
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        return textFiled
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onContinueButtonClicked), for: .primaryActionTriggered)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(CometChatTheme.white, for: .normal)
        button.backgroundColor = CometChatTheme.primaryColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = CometChatSpacing.Radius.r2
        return button
    }()
    
    var selectedRegion = ""
    var isPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
    @objc func onRegionSelected(_ sender: UIButton) {
        
        //updating the last selected button's UI
        euRegionButton.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        euRegionButton.backgroundColor = .clear
        
        indiaRegionButton.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        indiaRegionButton.backgroundColor = .clear
        
        usRegionButton.layer.borderColor = CometChatTheme.borderColorDefault.cgColor
        usRegionButton.backgroundColor = .clear
        
        
        sender.backgroundColor = CometChatTheme.primaryColor.withAlphaComponent(0.2)
        sender.layer.borderColor = CometChatTheme.primaryColor.cgColor
        switch sender.tag {
        case 1:
            selectedRegion = "us"
        case 2:
            selectedRegion = "in"
        case 3:
            selectedRegion = "eu"
        default:
            break
        }
        
    }
    
    func buildUI() {
        view.backgroundColor = CometChatTheme.backgroundColor01
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        containerView.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.addSubview(appCredentialsLabel)
        NSLayoutConstraint.activate([
            appCredentialsLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: CometChatSpacing.Padding.p5),
            appCredentialsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.addSubview(regionLabel)
        NSLayoutConstraint.activate([
            regionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            regionLabel.topAnchor.constraint(equalTo: appCredentialsLabel.bottomAnchor, constant: CometChatSpacing.Padding.p10)
        ])
        
        containerView.addSubview(regionStackView)
        NSLayoutConstraint.activate([
            regionStackView.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 5),
            regionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            regionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)

        ])
        
        containerView.addSubview(appIDTextFiled)
        NSLayoutConstraint.activate([
            appIDTextFiled.topAnchor.constraint(equalTo: regionStackView.bottomAnchor, constant: 20),
            appIDTextFiled.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            appIDTextFiled.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerView.addSubview(authKeyTextField)
        NSLayoutConstraint.activate([
            authKeyTextField.topAnchor.constraint(equalTo: appIDTextFiled.bottomAnchor, constant: 20),
            authKeyTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            authKeyTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: authKeyTextField.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func checkForError() -> Bool {
        var errorMessage: String?
        if selectedRegion.isEmpty {
            errorMessage = "Please select a region"
        }else if appIDTextFiled.textField.text == nil || appIDTextFiled.textField.text == "" {
            errorMessage = "Please enter App ID properly"
        }else if authKeyTextField.textField.text == nil || authKeyTextField.textField.text == "" {
            errorMessage = "Please enter Auth Key properly"
        }
        
        if let errorMessage = errorMessage  {
            showAlert("Fill Proper", errorMessage, "Cancle", "") { }
            return false
        } else {
            return true
        }
    }
    
    @objc func onContinueButtonClicked() {
        
        if checkForError() {
            
            let defaults = UserDefaults.standard
            defaults.set(appIDTextFiled.textField.text ?? "", forKey: "appID")
            defaults.set(selectedRegion, forKey: "region")
            defaults.set(authKeyTextField.textField.text ?? "", forKey: "authKey")
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate {
                sceneDelegate.initialisationCometChatUIKit(completion: {
                    if self.isPresented{
                        self.dismiss(animated: true)
                    }else{
                        sceneDelegate.setRootViewController(UINavigationController(rootViewController: LoginWithUidVC()))
                    }
                })
            }
            
        }
    }

}
