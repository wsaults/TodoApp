//
//  TodoCell.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodoCellDelegate: AnyObject {
    func isUpdatingContent(_ text: String)
    func didUpdate(text: String, isComplete: Bool)
    func didDelete()
}

public final class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    
    private enum Constants {
        static let horizontalMargin = 20.0
        static let radioButtonHeight = 24.0
        static let spacing = 10.0
        static let deleteButtonHeight = 40.0
        static let deleteButtonImageName = "xmark"
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
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.deleteButtonHeight / 2, weight: .bold, scale: .medium))
        let action = UIAction(handler: { [weak self] _ in self?.deleteButtonTapped() })
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }()
    
    public lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        textView.autocapitalizationType = .sentences
        textView.tintColor = .black
        textView.isScrollEnabled = false
        return textView
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
        contentView.addSubview(taskTextView)
        contentView.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        taskTextView.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            
            taskTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            taskTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            taskTextView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.spacing),
            
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            deleteButton.leadingAnchor.constraint(equalTo: taskTextView.trailingAnchor, constant: Constants.spacing),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalMargin),
        ])
    }
    
    private func radioButtonTapped(isComplete: Bool) {
        setCompleted(isComplete: isComplete)
        delegate?.didUpdate(text: taskTextView.text ?? "", isComplete: isComplete)
    }
    
    public func setCompleted(isComplete: Bool) {
        taskTextView.textColor = isComplete ? UIColor.red : UIColor.black
        radioButton.isSelected = isComplete
    }
    
    private func deleteButtonTapped() {
        delegate?.didDelete()
    }
}

extension TodoCell: UITextViewDelegate {
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdate(text: textView.text ?? "", isComplete: radioButton.isSelected)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        delegate?.isUpdatingContent(text)
    }
}
