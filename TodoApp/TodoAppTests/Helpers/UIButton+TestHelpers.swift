//
//  UIButton+TestHelpers.swift
//  TodoAppTests
//
//  Created by Will Saults on 2/7/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
    
    func simulateTouchesBegan() {
        touchesBegan(Set([UITouch()]), with: nil)
    }
}
