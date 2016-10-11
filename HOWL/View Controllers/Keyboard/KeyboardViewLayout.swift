//
//  KeyboardViewLayout.swift
//  HOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

protocol KeyboardViewLayoutDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, pathForItemAtIndexPath indexPath: IndexPath) -> UIBezierPath?
}

class KeyboardViewLayout: UICollectionViewLayout {
    
    // MARK: - Overrides

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                if let attributes = layoutAttributesForItem(at: indexPath) {
                    if rect.intersects(attributes.frame) {
                        layoutAttributes.append(attributes)
                    }
                }
            }
        }
        
        return layoutAttributes;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if let collectionView = collectionView, let delegate = collectionView.delegate as? KeyboardViewLayoutDelegate {
            if let path = delegate.collectionView(collectionView, layout: self, pathForItemAtIndexPath: indexPath) {
                attributes.frame = path.bounds
            }
        }
        
        return attributes
    }
    
}
