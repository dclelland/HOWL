//
//  KeyboardViewLayout.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol KeyboardViewLayoutDelegate: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: NSIndexPath) -> UIBezierPath
}

class KeyboardViewLayout: UICollectionViewLayout {
    
    // MARK: - Overrides

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.collectionView?.bounds.size ?? CGSizeZero
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else {
            return nil
        }
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for section in 0..<collectionView.numberOfSections() {
            for item in 0..<collectionView.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath.init(forItem: item, inSection: section)
                if let attributes = self.layoutAttributesForItemAtIndexPath(indexPath) {
                    if CGRectIntersectsRect(rect, attributes.frame) {
                        layoutAttributes.append(attributes)
                    }
                }
            }
        }
        
        return layoutAttributes;
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        if let collectionView = self.collectionView, let delegate = collectionView.delegate as? KeyboardViewLayoutDelegate {
            attributes.frame = delegate.collectionView(collectionView, layout: self, pathForItemAtIndexPath: indexPath).bounds
        }
        
        return attributes
    }
    
}
