//
//  PagingMenuCollectionView.swift
//  Parchment
//
//  Created by 吴哲 on 2024/3/18.
//  Copyright © 2024 Martin Rechsteiner. All rights reserved.
//

import UIKit

public final class PagingMenuCollectionView: UICollectionView {

    /// Whether to enable the function of classification nesting and paging
    var isCategoryNestPagingEnabled = false

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isCategoryNestPagingEnabled, let panGestureClass = NSClassFromString("UIScrollViewPanGestureRecognizer"), gestureRecognizer.isMember(of: panGestureClass), let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocityX = panGesture.velocity(in: panGesture.view).x
            if velocityX > 0 {
                if contentOffset.x == 0 {
                    return false
                }
            } else if velocityX < 0 {
                if contentSize.width <= bounds.width || contentOffset.x + bounds.width == contentSize.width {
                    return false
                }
            }
        }
        return true
    }
}
