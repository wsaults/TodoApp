//
//  UIButton+TestHelpers.swift
//  TodoAppTests
//
//  Created by Will Saults on 2/7/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        sendActions(for: .touchUpInside)
    }
    
    func simulateTouchesBegan() {
        touchesBegan(Set([UITouch()]), with: nil)
    }
}
