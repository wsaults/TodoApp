//
//  UIRefreshControl+TestHelpers.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

extension UIRefreshControl {
   func simulatePullToRefresh() {
       allTargets.forEach { target in
           actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
               (target as NSObject).perform(Selector($0))
           }
       }
   }
}
