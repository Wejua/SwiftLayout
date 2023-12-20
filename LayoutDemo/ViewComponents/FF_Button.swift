//
//  FF_Button.swift
//  FaceFate
//
//  Created by flqy on 2023/12/8.
//

import UIKit
import SnapKit

struct FF_ButtonTitle {
    var text: String
    var font: UIFont
    var textColor: UIColor
    
    init(text: String, font: UIFont, textColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}

enum FF_ButtonTitlePosition {
    case left
    case right
    case bottom
    case top
}

class FF_Button: UIView {
    //MARK: - 重写
    init(position: FF_ButtonTitlePosition? = nil, title: FF_ButtonTitle, selectedTitle: FF_ButtonTitle?) {
        self.buttonTitle = title
        self.selectedButtonTitle = selectedTitle
        super.init(frame: .zero)
        if let position = position {
            self.titlePosition = position
        }
        self.setupSelectState()
        self.setupPosition()
        self.addSubViews()
    }
    
    init(position: FF_ButtonTitlePosition? = nil, image: UIImage?, selectedImage: UIImage?) {
        self.image = image
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        if let position = position {
            self.titlePosition = position
        }
        self.setupSelectState()
        self.setupPosition()
        self.addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        if let intrinsicSizeCustom = intrinsicSizeCustom {
            return intrinsicSizeCustom
        } else {
            return self.caculateIntrinsicSize()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEnable = false
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEnable = true
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isEnable = true
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        super.touchesEstimatedPropertiesUpdated(touches)
    }
    
    //MARK: - 公有
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    let imageView: UIImageView = UIImageView()
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            stackV.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(contentOffset.horizontal)
                make.centerY.equalToSuperview().offset(contentOffset.vertical)
                make.top.greaterThanOrEqualToSuperview().offset(contentInset.top)
                make.left.greaterThanOrEqualToSuperview().offset(contentInset.left)
                make.right.lessThanOrEqualToSuperview().offset(-contentInset.right)
                make.bottom.lessThanOrEqualToSuperview().offset(-contentInset.right)
            }
        }
    }
    var contentOffset: UIOffset = .zero {
        didSet {
            stackV.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(contentOffset.horizontal)
                make.centerY.equalToSuperview().offset(contentOffset.vertical)
                make.top.greaterThanOrEqualToSuperview().offset(contentInset.top)
                make.left.greaterThanOrEqualToSuperview().offset(contentInset.left)
                make.right.lessThanOrEqualToSuperview().offset(-contentInset.right)
                make.bottom.lessThanOrEqualToSuperview().offset(-contentInset.right)
            }
        }
    }
    var spacingOfTitleAndImage: CGFloat = 0 {
        didSet {
            self.stackV.spacing = spacingOfTitleAndImage
        }
    }
    var intrinsicSizeCustom: CGSize?
    var backgroundImage: UIImage? {
        didSet {
            setupSelectState()
        }
    }
    var selectedBackgroundImage: UIImage? {
        didSet {
            setupSelectState()
        }
    }
    var isSelected: Bool = false {
        didSet {
            self.setupSelectState()
        }
    }
    var isEnable: Bool = true {
        didSet {
            if isEnable {
                self.isUserInteractionEnabled = true
                self.contentView.alpha = 1
            } else {
                self.isUserInteractionEnabled = false
                self.contentView.alpha = 0.5
            }
        }
    }
    
    func setup(title: FF_ButtonTitle?=nil, selectedTitle: FF_ButtonTitle?=nil, image: UIImage?=nil, selectedImage: UIImage?=nil, backgroundImage: UIImage?=nil, selectedBackgroundImage: UIImage?=nil) {
        if let title = title {
            self.buttonTitle = title
        }
        if let selectedTitle = selectedTitle {
            self.selectedButtonTitle = selectedTitle
        }
        if let image = self.image {
            self.image = image
        }
        if let selectedImage = selectedImage {
            self.selectedImage = selectedImage
        }
        if let backgroundImage = backgroundImage {
            self.backgroundImage = backgroundImage
        }
        if let selectedBackgroundImage = selectedBackgroundImage {
            self.selectedBackgroundImage = selectedBackgroundImage
        }
    }
    
    //MARK: - 私有
    private var titlePosition: FF_ButtonTitlePosition = .right
    var buttonTitle: FF_ButtonTitle? {
        didSet {
            self.setupSelectState()
        }
    }
    var selectedButtonTitle: FF_ButtonTitle? {
        didSet {
            self.setupSelectState()
        }
    }
    private var image: UIImage? {
        didSet {
            self.setupSelectState()
        }
    }
    private var selectedImage: UIImage? {
        didSet {
            self.setupSelectState()
        }
    }
    private var stackV: UIStackView = UIStackView()
    private var backgroundImageV = UIImageView()
    private var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private func addSubViews() {
        self.addSubview(contentView)
        contentView.addSubview(backgroundImageV)
        contentView.addSubview(stackV)
        
        backgroundImageV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackV.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(contentOffset.horizontal)
            make.centerY.equalToSuperview().offset(contentOffset.vertical)
            make.top.greaterThanOrEqualToSuperview().offset(contentInset.top)
            make.left.greaterThanOrEqualToSuperview().offset(contentInset.left)
            make.right.lessThanOrEqualToSuperview().offset(-contentInset.right)
            make.bottom.lessThanOrEqualToSuperview().offset(-contentInset.right)
        }
    }
    
    private func setupSelectState() {
        if isSelected {
            titleLabel.text = selectedButtonTitle?.text
            titleLabel.font = selectedButtonTitle?.font
            titleLabel.textColor = selectedButtonTitle?.textColor
            imageView.image = selectedImage
            backgroundImageV.image = selectedBackgroundImage
        } else {
            titleLabel.text = buttonTitle?.text
            titleLabel.font = buttonTitle?.font
            titleLabel.textColor = buttonTitle?.textColor
            imageView.image = image
            backgroundImageV.image = backgroundImage
        }
    }
    
    private func setupPosition() {
        switch self.titlePosition {
        case .left:
            stackV.addArrangedSubview(titleLabel)
            stackV.addArrangedSubview(imageView)
            stackV.axis = .horizontal
            stackV.distribution = .fillProportionally
            stackV.alignment = .center
            stackV.spacing = spacingOfTitleAndImage
        case .right:
            stackV.addArrangedSubview(imageView)
            stackV.addArrangedSubview(titleLabel)
            stackV.axis = .horizontal
            stackV.distribution = .fillProportionally
            stackV.alignment = .center
            stackV.spacing = spacingOfTitleAndImage
        case .bottom:
            stackV.addArrangedSubview(imageView)
            stackV.addArrangedSubview(titleLabel)
            stackV.axis = .vertical
            stackV.distribution = .fillProportionally
            stackV.alignment = .center
            stackV.spacing = spacingOfTitleAndImage
        case .top:
            stackV.addArrangedSubview(titleLabel)
            stackV.addArrangedSubview(imageView)
            stackV.axis = .vertical
            stackV.distribution = .fillProportionally
            stackV.alignment = .center
            stackV.spacing = spacingOfTitleAndImage
        }
    }
    
    private func caculateIntrinsicSize() -> CGSize {
        switch self.titlePosition {
        case.left:
            let w = titleLabel.intrinsicContentSize.width + spacingOfTitleAndImage + imageView.intrinsicContentSize.width
            let h = max(titleLabel.intrinsicContentSize.height, imageView.intrinsicContentSize.height)
            return CGSize(width: w, height: h)
        case .right:
            let w = titleLabel.intrinsicContentSize.width + spacingOfTitleAndImage + imageView.intrinsicContentSize.width
            let h = max(titleLabel.intrinsicContentSize.height, imageView.intrinsicContentSize.height)
            return CGSize(width: w, height: h)
        case .bottom:
            let w = max(titleLabel.intrinsicContentSize.width, imageView.intrinsicContentSize.width)
            let h = titleLabel.intrinsicContentSize.height + spacingOfTitleAndImage + imageView.intrinsicContentSize.height
            return CGSize(width: w, height: h)
        case .top:
            let w = max(titleLabel.intrinsicContentSize.width, imageView.intrinsicContentSize.width)
            let h = titleLabel.intrinsicContentSize.height + spacingOfTitleAndImage + imageView.intrinsicContentSize.height
            return CGSize(width: w, height: h)
        }
    }
}
