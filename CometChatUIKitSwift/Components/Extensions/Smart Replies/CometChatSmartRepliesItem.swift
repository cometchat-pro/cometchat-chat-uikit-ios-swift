
//  CometChatSmartRepliesPreviewItem.swift
 
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2020 CometChat Inc. All rights reserved.


// MARK: - Importing Frameworks.
import UIKit
import CometChatSDK

// MARK: - Importing Protocols.

protocol CometChatSmartRepliesItemDelegate: AnyObject {
    func didSendButtonPressed(title: String, sender: UIButton)
}

/*  ----------------------------------------------------------------------------------------- */

class CometChatSmartRepliesItem: UICollectionViewCell {
    
    // MARK: - Declaration of IBOutlets
//    @IBOutlet weak var smartReplyButton: UIButton!
//    @IBOutlet weak var smartRepliesButtonView: UIView!
    
    
    public lazy var smartReplyButton: UIButton = {
        let button = UIButton().withoutAutoresizingMaskConstraints()
        return button
    }()
    
    public lazy var smartRepliesButtonView: UIView = {
        let view = UIView().withoutAutoresizingMaskConstraints()
        return view
    }()
    

    // MARK: - Declaration of Variables
    weak var smartRepliesItemDelegate: CometChatSmartRepliesItemDelegate?
    var title: String? {
        didSet {
            
            if let title = title , !title.isEmpty {
                applyShadow()
                smartReplyButton.setImage(nil, for: .normal)
                smartReplyButton.setTitle(title, for: .normal)
                set(style: SmartRepliesStyle())
            } else {
                smartReplyButton.setTitle(nil, for: .normal)
                smartReplyButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                smartReplyButton.tintColor = CometChatTheme_v4.palatte.accent500
                set(background: .clear)
                set(shadowColor: .clear)
                set(buttonBackground: .clear)
            }
        }
           
    }
    
    // MARK: - Initialization of required Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //TODO: - Redundant code.
        setupUI()
    }
    
    public func setupUI(){
        smartRepliesButtonView.embed(smartRepliesButtonView)
        smartRepliesButtonView.addSubview(smartReplyButton)
    }
    
    public func applyShadow() {
        smartRepliesButtonView.layer.masksToBounds = false
        smartRepliesButtonView.layer.shadowColor = CometChatTheme_v4.palatte.accent300.cgColor
        smartRepliesButtonView.layer.shadowOpacity = 0.8
        smartRepliesButtonView.layer.shadowOffset = CGSize.zero
        smartRepliesButtonView.layer.shadowRadius = 2
        smartRepliesButtonView.layer.shouldRasterize = true
        smartRepliesButtonView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    @discardableResult
    public  func set(style: SmartRepliesStyle) {
        set(background: style.background)
        set(shadowColor: style.shadowColor)
        set(buttonBackground: style.background)
        set(corner: style.borderRadius)
        set(textFont: style.textFont)
        set(textBackground: style.textBackground)
        set(titleColor: style.textColor)
    }
    
    @discardableResult
    public func set(background: UIColor) -> Self {
        smartRepliesButtonView.backgroundColor = background
        return self
    }
    
    @discardableResult
    public func set(shadowColor: UIColor) -> Self {
        smartRepliesButtonView.layer.shadowColor = shadowColor.cgColor
        return self
    }
    
    @discardableResult
    public func set(buttonBackground: UIColor) -> Self {
        smartReplyButton.backgroundColor = buttonBackground
        return self
    }
    
    @discardableResult
    public func set(corner: CometChatCornerStyle) -> Self {
        smartReplyButton.roundViewCorners(corner: corner)
        return self
    }
    
    @discardableResult
    public func set(textFont: UIFont) -> Self {
        smartReplyButton.titleLabel?.font = textFont
        return self
    }
    
    @discardableResult
    public func set(titleColor: UIColor) -> Self {
        smartReplyButton.setTitleColor(titleColor, for: .normal)
        return self
    }
    
    @discardableResult func set(textBackground: UIColor) -> Self {
        smartReplyButton.backgroundColor = textBackground
        return self
    }
    
    /// This method will trigger when user pressed button on smart reply cell.
    /// - Parameter sender: specifies a sender of the button.
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        smartRepliesItemDelegate?.didSendButtonPressed(title: title ?? "", sender: sender)
        smartReplyButton.titleLabel?.text = nil
     }
}

/*  ----------------------------------------------------------------------------------------- */
