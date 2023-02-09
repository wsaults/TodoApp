//
//  UITextView+TextPublisher.swift
//  TodoiOS
//
//  Created by Will Saults on 2/8/23.
//

import Combine
import UIKit

extension UITextView {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextView)?.text }
        .eraseToAnyPublisher()
    }
}
