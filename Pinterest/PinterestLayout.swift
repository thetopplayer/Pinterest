//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Mic Pringle on 10/03/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
  
  func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
  
}

class PinterestLayout: UICollectionViewLayout {
  
  var delegate: PinterestLayoutDelegate!
  var numberOfColumns = 1
  
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight: CGFloat = 0
  private var width: CGFloat {
    get {
      return CGRectGetWidth(collectionView!.bounds)
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
        let height = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath)
        let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = frame
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
