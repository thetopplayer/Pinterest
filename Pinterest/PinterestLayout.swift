//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Mic Pringle on 10/03/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
  
  func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
  
}

class PinterestLayout: UICollectionViewLayout {
  
  var cellPadding: CGFloat = 0
  var delegate: PinterestLayoutDelegate!
  var numberOfColumns = 1
  
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var width: CGFloat {
    get {
      let insets = collectionView!.contentInset
      return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: width, height: contentHeight)
  }
  
  override func prepareLayout() {
    if cache.isEmpty {
      let columnWidth = width / CGFloat(numberOfColumns)
      
      var xOffsets = [CGFloat]()
      for column in 0..<numberOfColumns {
        xOffsets.append(CGFloat(column) * columnWidth)
      }
      
      var yOffsets = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      
      var column = 0
      for item in 0..<collectionView!.numberOfItemsInSection(0) {
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        
        let width = columnWidth - (cellPadding * 2)
        let itemHeight = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth: width)
        let height = itemHeight + (cellPadding * 2)
        
        let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
        let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
        yOffsets[column] = yOffsets[column] + height
        column = column >= (numberOfColumns - 1) ? 0 : ++column
      }
    }
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attributes in cache {
      if CGRectIntersectsRect(attributes.frame, rect) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
}
