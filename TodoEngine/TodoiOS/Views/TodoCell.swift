//
//  TodoCell.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import Combine
import UIKit

public protocol TodoCellDelegate: AnyObject {
    func isUpdatingContent(_ text: String)
    func shouldUpdateUI()
    func didUpdate(text: String, isComplete: Bool)
    func didDelete()
}

public final class TodoCell: UITableViewCell {
    
    weak var delegate: TodoCellDelegate?
    
    private enum Constants {
        static let horizontalMargin = 20.0
        static let radioButtonHeight = 24.0
        static let spacing = 10.0
        static let halfSpacing = spacing / 2
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
        configuration.baseForegroundColor = .systemRed
        configuration.baseBackgroundColor = .clear
        
        configuration.image = UIImage(
            systemName: Constants.deleteButtonImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.deleteButtonHeight / 2, weight: .bold, scale: .medium))
        let action = UIAction(handler: { [weak self] _ in self?.deleteButtonTapped() })
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }()

    private var textPublisherCancellable = Set<AnyCancellable>()
    public lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.autocapitalizationType = .sentences
        textView.tintColor = .secondaryLabel
        textView.isScrollEnabled = false
        textView.adjustContainerInset()
        textView.textPublisher
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                self?.delegate?.isUpdatingContent(text)
            }).store(in: &textPublisherCancellable)
        return textView
    }()
    
    public lazy var placeholderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "You'll be done in no time!"
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.isHidden = true
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
        contentView.addSubview(placeholderTextField)
        contentView.addSubview(taskTextView)
        contentView.addSubview(deleteButton)
    }
    
    private func setConstraints() {
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderTextField.translatesAutoresizingMaskIntoConstraints = false
        taskTextView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.halfSpacing),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonHeight),
            
            placeholderTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -Constants.halfSpacing),
            placeholderTextField.leadingAnchor.constraint(equalTo: taskTextView.leadingAnchor, constant: Constants.halfSpacing),
            placeholderTextField.trailingAnchor.constraint(equalTo: taskTextView.trailingAnchor),
            placeholderTextField.heightAnchor.constraint(equalToConstant: 40),
            
            taskTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.halfSpacing),
            taskTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            taskTextView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Constants.spacing),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.halfSpacing),
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
        taskTextView.textColor = isComplete ? .systemRed : .label
        radioButton.isSelected = isComplete
    }
    
    private func deleteButtonTapped() {
        delegate?.didDelete()
    }
    
    public func hidePlaceholderField(_ hide: Bool) {
        placeholderTextField.isHidden = hide
    }
}

extension TodoCell: UITextViewDelegate {
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdate(text: textView.text ?? "", isComplete: radioButton.isSelected)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        delegate?.shouldUpdateUI()
        textView.adjustContainerInset()
        hidePlaceholderField(!textView.text.isEmpty)
    }
}
