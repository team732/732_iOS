//
//  PhotoCaptionCell.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit

class PhotoCaptionCell: UICollectionViewCell {
    // MARK: Layout Concerns
    fileprivate var didSetUpView: Bool = false
    fileprivate var calculatedTextHeight: CGFloat? {
        didSet {
            textHeightLayoutConstraint?.constant = calculatedTextHeight!
        }
    }
    
    // MARK: Constraints
    fileprivate var textHeightLayoutConstraint: NSLayoutConstraint?
    fileprivate var stackViewConstraints: [NSLayoutConstraint]! = nil
    fileprivate var titleLabelToCaptionViewConstraints: [NSLayoutConstraint]! = nil
    
    // MARK: Lazy UI
    fileprivate lazy var captionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.titleLabel)
        
        return view
    }()
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    fileprivate lazy var mainView: UIView = {
        let view = UIStackView(arrangedSubviews: [self.imageView, self.captionView])
        
        view.axis = UILayoutConstraintAxis.vertical
        view.distribution = UIStackViewDistribution.equalSpacing
        view.alignment = UIStackViewAlignment.fill
        view.isLayoutMarginsRelativeArrangement = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Public init
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        self.stackViewConstraints = [
            NSLayoutConstraint(
                item: mainView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: mainView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: mainView,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: mainView,
                attribute: .height,
                relatedBy: .equal,
                toItem: self,
                attribute: .height,
                multiplier: 1,
                constant: 0)
        ]
        
        self.titleLabelToCaptionViewConstraints = [
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .leading,
                relatedBy: .equal,
                toItem: captionView,
                attribute: .leading,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: captionView,
                attribute: .trailing,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: captionView,
                attribute: .top,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: titleLabel,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: captionView,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: 0)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpWithImage(_ image: UIImage, title: String, style: PhotoCaptionCellStyle) {
        imageView.image = image
        titleLabel.text = title
        
        // Keep track of set up status, because we're reusing cells
        guard didSetUpView else {
            setUpView(style)
            return
        }
        
        applyStyle(style)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MultipleColumnLayoutAttributes else {
            fatalError("Unexpected attributes class")
        }
        calculatedTextHeight = attributes.annotationHeight
        
        if didSetUpView {
            removeConstraints(stackViewConstraints)
            addConstraints(stackViewConstraints)
        }
    }
    
    // MARK: Private view
    
    fileprivate func applyStyle(_ style: PhotoCaptionCellStyle) {
        backgroundColor = style.backgroundColor
        titleLabel.font = style.titleFont
        
        // Update constraint constants
        titleLabelToCaptionViewConstraints[0].constant = style.titleInsets.top
        titleLabelToCaptionViewConstraints[1].constant = -style.titleInsets.bottom
        titleLabelToCaptionViewConstraints[2].constant = style.titleInsets.left
        titleLabelToCaptionViewConstraints[3].constant = -style.titleInsets.right
    }
    
    fileprivate func setUpView(_ style: PhotoCaptionCellStyle) {
        // Add views to contentView
        addSubview(mainView)
        
        // Constraint stackView to cell's edges
        addConstraints(stackViewConstraints)
        
        // Add default padding around title label
        addConstraints(titleLabelToCaptionViewConstraints)
        
        /// Sets text height constraint
        textHeightLayoutConstraint = NSLayoutConstraint(item: captionView,
                                                        attribute: .height,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1,
                                                        constant: calculatedTextHeight ?? 30)
        if let textHeightLayoutConstraint = textHeightLayoutConstraint {
            addConstraint(textHeightLayoutConstraint)
        }
        
        // Apply style
        applyStyle(style)
        
        didSetUpView = true
    }
}

// MARK: Style

protocol PhotoCaptionCellStyle {
    var backgroundColor: UIColor { get }
    var cornerRadius: CGFloat { get }
    var titleFont: UIFont { get }
    var titleInsets: UIEdgeInsets { get }
}

struct BeigeRoundedPhotoCaptionCellStyle: PhotoCaptionCellStyle {
    let backgroundColor = UIColor.green.withAlphaComponent(0.2)
    let cornerRadius: CGFloat = 5
    let titleFont = UIFont(name: "Avenir", size: 12) ?? UIFont.systemFont(ofSize: 12)
    let titleInsets = UIEdgeInsetsMake(5, 5, 5, 5)
}
