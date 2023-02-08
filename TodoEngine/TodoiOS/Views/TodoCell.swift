//
//  TodoCell.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodoCellDelegate: AnyObject {
    func didUpdate(text: String, isComplete: Bool)
    func didDelete()
}

public final class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    
    private enum Constants {
        static let horizontalMargin = 20.0
        static let radioButtonHeight = 24.0
        static let spacing = 10.0
        static let taskFieldHeight = 30.0
        static let deleteButtonHeight = 40.0
        static let deleteButtonImageName = "x.circle"
    }
    
    public lazy var radioButton: RadioButton = {
        let button = RadioButton()
        button.completeTodo = radioButtonTapped
        return button
    }()
    
    public lazy var deleteButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .red
        configuration.baseBackgroundColor = .clear
        
        configuration.image = UIImage(
            systemName: Constants.deleteButtonImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.deleteButtonHeight / 2, weight: .bold, scale: .large))
        let action = UIAction(handler: { [weak self] _ in self?.deleteButtonTapped() })
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }()
    
    public lazy var taskField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "You'll be done in no time!"
        textField.delegate = self
        textField.returnKeyType = .done
        textField.autocapitalizationType = .sentences
        textField.tintColor = .black
        return textField
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
        contentView.addSubview(radioButton)
        contentView.addSubview(taskField)
        contentView.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        taskField.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            
            taskField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskField.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.spacing),
            taskField.heightAnchor.constraint(equalToConstant: Constants.taskFieldHeight),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: taskField.trailingAnchor, constant: Constants.spacing),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
        ])
    }
    
    private func radioButtonTapped(isComplete: Bool) {
        setCompleted(isComplete: isComplete)
        delegate?.didUpdate(text: taskField.text ?? "", isComplete: isComplete)
    }
    
    public func setCompleted(isComplete: Bool) {
        taskField.textColor = isComplete ? UIColor.red : UIColor.black
        radioButton.isSelected = isComplete
    }
    
    private func deleteButtonTapped() {
        delegate?.didDelete()
    }
}

extension TodoCell: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didUpdate(text: textField.text ?? "", isComplete: radioButton.isSelected)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
