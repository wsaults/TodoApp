//
//  UITextView+Inset.swift
//  TodoiOS
//
//  Created by Will Saults on 2/9/23.
//

import UIKit

extension UITextView {
    func adjustContainerInset() {
        textContainerInset = UIEdgeInsets(top: 0, left: textContainerInset.left, bottom: textContainerInset.bottom, right: textContainerInset.right)
    }
}
