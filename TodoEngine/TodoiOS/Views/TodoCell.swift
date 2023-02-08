//
//  TodoCell.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodoCellDelegate: AnyObject {
    func cellDidUpdate(isComplete: Bool)
}

public final class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    
    private enum Constants {
        static let horizontalMargin = 20.0
        static let radioButtonHeight = 24.0
        static let spacing = 10.0
        static let taskLabelHeight = 30.0
    }
    
    public lazy var radioButton: RadioButton = {
        let button = RadioButton()
        button.completeTodo = radioButtonTapped
        return button
    }()
    
    public lazy var taskLabel: UILabel = {
        UILabel()
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(radioButton)
    }
    
    private func setConstraints() {
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.spacing),
            taskLabel.heightAnchor.constraint(equalToConstant: Constants.taskLabelHeight),
            taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
        ])
    }
    
    private func radioButtonTapped(isComplete: Bool) {
        setCompleted(isComplete: isComplete)
        delegate?.cellDidUpdate(isComplete: isComplete)
    }
    
    public func setCompleted(isComplete: Bool) {
        taskLabel.textColor = isComplete ? UIColor.red : UIColor.black
        radioButton.isSelected = isComplete
    }
}
