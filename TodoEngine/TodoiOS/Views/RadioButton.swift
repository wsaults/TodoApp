//
//  RadioButton.swift
//  TodoiOS
//
//  Created by Will Saults on 2/7/23.
//

import UIKit

public class RadioButton: UIButton {
    
    enum Constants {
        static let cornerRadius = 5.0
        static let borderWidth = 2.0
    }
    
    public var completeTodo: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        toggleButton()
        completeTodo?(isSelected)
    }
    
    public override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemRed.cgColor : UIColor.systemGray.cgColor
            layer.backgroundColor = isSelected ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        }
    }
    
    private func toggleButton() {
        isSelected.toggle()
    }
}
