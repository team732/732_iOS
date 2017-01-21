//
//  MultipleColumnLayout.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit

// Inspired by: RayWenderlich.com pinterest-basic-layout
protocol MultipleColumnLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat
}

class MultipleColumnLayoutAttributes: UICollectionViewLayoutAttributes {
    var annotationHeight: CGFloat = 0
    var photoHeight: CGFloat = 0
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copy = super.copy(with: zone) as? MultipleColumnLayoutAttributes else {
            fatalError()
        }
        copy.annotationHeight = annotationHeight
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? MultipleColumnLayoutAttributes else {
            return false
        }
        if attributes.photoHeight == photoHeight && attributes.annotationHeight == annotationHeight {
            return super.isEqual(object)
        }
        return false
    }
}

class MultipleColumnLayout: UICollectionViewLayout {
    // MARK: Public API
    weak var delegate: MultipleColumnLayoutDelegate!
    var numberOfColumns = 1
    var cellPadding: CGFloat = 0
    
    // MARK: Layout Concerns
    fileprivate var cache = [MultipleColumnLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var width: CGFloat {
        get {
            guard let collectionView = collectionView else {
                fatalError()
            }
            let insets = collectionView.contentInset
            let width = collectionView.bounds.width
            return width - (insets.left + insets.right)
        }
    }
    
    convenience init(cellPadding: CGFloat, numberOfColumns: Int) {
        self.init()
        self.cellPadding = cellPadding
        self.numberOfColumns = numberOfColumns
    }
    
    // MARK: Public API
    
    func clearCache() {
        cache.removeAll()
    }
    
    override class var layoutAttributesClass : AnyClass {
        return MultipleColumnLayoutAttributes.self
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var layoutAttributes = [UICollectionViewLayoutAttributes]()
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    layoutAttributes.append(attributes)
                }
            }
            return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            let attributes = MultipleColumnLayoutAttributes(forCellWith: indexPath)
            let frame = CGRect(x: -231, y: -231, width: 1, height: 1).insetBy(dx: cellPadding, dy: cellPadding)
            attributes.frame = frame
            return attributes
    }
    
    override func prepare() {
        if cache.isEmpty {
            guard let collectionView = collectionView else {
                return
            }
            let columnWidth = width / CGFloat(numberOfColumns)
            
            // Create arrays to hold x and y offsets of each
            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append((CGFloat(column) * columnWidth))
            }
            
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            
            var column = 0
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let width = columnWidth - (cellPadding * 2)
                
                // Calculate height
                let photoHeight = delegate.collectionView(collectionView,
                                                          heightForPhotoAtIndexPath: indexPath,
                                                          withWidth: width)
                let annotationHeight = delegate.collectionView(collectionView,
                                                               heightForAnnotationAtIndexPath: indexPath,
                                                               withWidth: width)
                let height = cellPadding + photoHeight + annotationHeight + cellPadding
                
                let frame = CGRect(x: xOffsets[column],
                                   y: yOffsets[column],
                                   width: columnWidth,
                                   height: height).insetBy(dx: cellPadding,
                                                           dy: cellPadding)
                
                let attributes = MultipleColumnLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                attributes.photoHeight = photoHeight
                attributes.annotationHeight = annotationHeight
                
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
}
