//
//  LoginWithUidVC.swift
//  master-app
//
//  Created by Suryansh on 23/12/24.
//

import UIKit
import CometChatUIKitSwift

class LoginWithUidVC: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cometchat-logo-with-name")?.withRenderingMode(.alwaysOriginal)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 134).isActive = true
        return imageView
    }()
    
    lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in to cometchat"
        label.font = CometChatTypography.Heading2.bold
        label.textColor = CometChatTheme.textColorPrimary
        return label
    }()
    
    lazy var chooseSampleUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose a Sample Users"
        label.font = CometChatTypography.Body.medium
        label.textColor = CometChatTheme.textColorPrimary
        return label
    }()
    
    lazy var sampleUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        return collectionView
    }()
    
    lazy var dividerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let divider1 = UIView()
        divider1.translatesAutoresizingMaskIntoConstraints = false
        divider1.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
        divider1.backgroundColor = CometChatTheme.textColorPrimary.withAlphaComponent(0.4)
        view.addSubview(divider1)

        let orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.text = "  or  "
        orLabel.backgroundColor = CometChatTheme.backgroundColor01
        orLabel.textColor = CometChatTheme.neutralColor500
        orLabel.font = CometChatTypography.Body.medium
        view.addSubview(orLabel)
        
        NSLayoutConstraint.activate([
            divider1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            orLabel.centerYAnchor.constraint(equalTo: divider1.centerYAnchor),
            orLabel.centerXAnchor.constraint(equalTo: divider1.centerXAnchor)
        ])
        
        return view
    }()
    
    lazy var uidTextField: CustomTextFiled = {
        let textFiled = CustomTextFiled(leadingText: "UID", placeholderText: "Enter Your UID")
        textFiled.textField.delegate = self
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
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var changeAppCredentialsLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let fullText = "Change App Credentials"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [.foregroundColor: CometChatTheme.primaryColor]
        )
        attributedText.addAttribute(
            .foregroundColor,
            value: CometChatTheme.textColorPrimary,
            range: (fullText as NSString).range(of: "Change")
        )
        button.setAttributedTitle(attributedText, for: .normal)
        button.titleLabel?.font = CometChatTypography.Body.regular
        button.addTarget(self, action: #selector(onAppCredentialChangeButtonClicked), for: .primaryActionTriggered)
        return button
    }()
    
    var sampleUsers: [(name: String, uid: String, avatar: String)] = [(name: String, uid: String, avatar: String)]() {
        didSet {
            DispatchQueue.main.async(execute: { [weak self] in
                self?.sampleUserCollectionView.reloadData()
            })
        }
    }
    var selectedSampleUser: (name: String, uid: String, avatar: String)?
    lazy var keyboardDismissGusture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    var selectedUID = -1


    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        fetchUserData()
        sampleUserCollectionView.register(SampleUserCVCell.self, forCellWithReuseIdentifier: "SampleUserCVCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    open func handleThemeModeChange() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
                self.logoImageView.image = UIImage(named: "cometchat-logo-with-name")?.withRenderingMode(.alwaysOriginal)
            })
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Check if the user interface style has changed
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            logoImageView.image = UIImage(named: "cometchat-logo-with-name")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.removeGestureRecognizer(keyboardDismissGusture)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.containerView.transform = .identity
        })
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.view.addGestureRecognizer(keyboardDismissGusture)
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.containerView.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight/2))
            })
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
        
        containerView.addSubview(signInLabel)
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: CometChatSpacing.Padding.p5),
            signInLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        containerView.addSubview(chooseSampleUserLabel)
        NSLayoutConstraint.activate([
            chooseSampleUserLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            chooseSampleUserLabel.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: CometChatSpacing.Padding.p10)
        ])
        
        containerView.addSubview(sampleUserCollectionView)
        NSLayoutConstraint.activate([
            sampleUserCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sampleUserCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sampleUserCollectionView.topAnchor.constraint(equalTo: chooseSampleUserLabel.bottomAnchor, constant: 8),
            sampleUserCollectionView.heightAnchor.constraint(equalToConstant: 270)
        ])
        
        containerView.addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: sampleUserCollectionView.bottomAnchor, constant: 0),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        containerView.addSubview(uidTextField)
        NSLayoutConstraint.activate([
            uidTextField.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 15),
            uidTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            uidTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        containerView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: uidTextField.bottomAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        containerView.addSubview(changeAppCredentialsLabel)
        NSLayoutConstraint.activate([
            changeAppCredentialsLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10),
            changeAppCredentialsLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
        
    }
    
    @objc func onAppCredentialChangeButtonClicked() {
        let ChangeAppCredentialsVC = ChangeAppCredentialsVC()
        self.present(ChangeAppCredentialsVC, animated: true)
    }
    
    @objc func onContinueButtonClicked() {
        if let uid = selectedSampleUser?.uid ?? uidTextField.textField.text, !uid.isEmpty {
            self.continueButton.showLoading()
            CometChatUIKit.login(uid: uid) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.continueButton.hideLoading(withTitle: "Continue")
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                        sceneDelegate.setRootViewController(UINavigationController(rootViewController: HomeScreenViewController()))
                    }
                    break
                case .onError(let error):
                    DispatchQueue.main.async {
                        self.continueButton.hideLoading(withTitle: "Continue")
                        self.presentSomethingWentWrongAlert(error: error.errorDescription)
                    }
                @unknown default:
                    break
                }
            }
        }
    }
    
    func presentSomethingWentWrongAlert(error: String) {
        let alert = UIAlertController(
            title: "Something went wrong!",
            message: error,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }


}

extension LoginWithUidVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleUsers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SampleUserCVCell", for: indexPath) as! SampleUserCVCell
        if selectedUID == indexPath.row{
            cell.didSelect()
        }else{
            cell.didDeselect()
        }
        cell.set(data: sampleUsers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedUID == indexPath.row{
            selectedUID = -1
        }else{
            selectedUID = indexPath.row
            selectedSampleUser = sampleUsers[selectedUID]
        }
        collectionView.reloadData()
    }
}


extension LoginWithUidVC {
    
    func fetchUserData() {
        guard let url = URL(string: "https://assets.cometchat.io/sampleapp/sampledata.json") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                self?.presentSomethingWentWrongAlert(error: error.localizedDescription)
                return
            }
            
            guard let data = data else {
                self?.presentSomethingWentWrongAlert(error: "No data Received")
                return
            }
            
            do {
                // Parse the JSON directly as a dictionary
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let users = json["users"] as? [[String: Any]] {
                    
                    // Convert the user data to tuple format
                    let userTuples: [(name: String, uid: String, avatar: String)] = users.compactMap { user in
                        if let name = user["name"] as? String,
                           let uid = user["uid"] as? String,
                           let avatar = user["avatar"] as? String {
                            return (name: name, uid: uid, avatar: avatar)
                        }
                        return nil
                    }
                    
                    self?.sampleUsers = userTuples
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

extension LoginWithUidVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

