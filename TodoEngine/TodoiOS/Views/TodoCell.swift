//
//  TodoCell.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodoCellDelegate: AnyObject {
    func didUpdate(isComplete: Bool)
    func didDelete()
}

public final class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    
    private enum Constants {
        static let horizontalMargin = 20.0
        static let radioButtonHeight = 24.0
        static let spacing = 10.0
        static let taskLabelHeight = 30.0
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
        contentView.addSubview(radioButton)
        contentView.addSubview(taskLabel)
        contentView.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.spacing),
            taskLabel.heightAnchor.constraint(equalToConstant: Constants.taskLabelHeight),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: taskLabel.trailingAnchor, constant: Constants.spacing),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
        ])
    }
    
    private func radioButtonTapped(isComplete: Bool) {
        setCompleted(isComplete: isComplete)
        delegate?.didUpdate(isComplete: isComplete)
    }
    
    public func setCompleted(isComplete: Bool) {
        taskLabel.textColor = isComplete ? UIColor.red : UIColor.black
        radioButton.isSelected = isComplete
    }
    
    private func deleteButtonTapped() {
        delegate?.didDelete()
    }
}
