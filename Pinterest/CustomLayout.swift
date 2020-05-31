//
//  customLayout.swift
//  Pinterest
//
//  Created by Ricardo González Pacheco on 22/05/2020.
//  Copyright © 2020 Ricardo González Pacheco. All rights reserved.
//

import UIKit

protocol CollectionCustomDelegate {
    func retrieveItemHeight(collectionView: UICollectionView, at indexPath: IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {
    
    var customDelegate: CollectionCustomDelegate?
 
    var cache: [UICollectionViewLayoutAttributes] = []
    
    let numberOfColumns: Int = 3
    let interItemSpacing: CGFloat = 6
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let inset = collectionView.contentInset
        return collectionView.bounds.width - inset.left - inset.right
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // item width
        let itemWidth = collectionView!.bounds.width / CGFloat(numberOfColumns)

        let startX: [CGFloat] = [0*itemWidth, 1*itemWidth, 2*itemWidth]
        var startY: [CGFloat] = [0, 0, 0]
        
        var column = 0
        
        for item in 0...collectionView!.numberOfItems(inSection: 0) - 1 {
            let indexPath = IndexPath(item: item, section: 0)
            
            // item height
            guard let photoHeight = customDelegate?.retrieveItemHeight(collectionView: collectionView!, at: indexPath) else { return }
            let height = interItemSpacing * 2 + photoHeight
            // Need to know item's frame to assign to corresponding attributes object inside cache array.
            let frame = CGRect(x: startX[column], y: startY[column], width: itemWidth, height: height)
            let insetFrame = frame.insetBy(dx: interItemSpacing, dy: interItemSpacing) // It reduces image for all sides in specific inset.
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Updating variables to next loop: column, startY, contentHeight
            startY[column] = startY[column] + height
            contentHeight = max(contentHeight, frame.maxY) // If I do not update content height it still works
            column = column < numberOfColumns - 1 ? column + 1 : 0
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for item in 0...cache.count - 1 {
            if cache[item].frame.intersects(rect) {
                visibleLayoutAttributes.append(cache[item])
            }
        }
        
        return visibleLayoutAttributes
    }
}
