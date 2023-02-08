//
//  TodoCell+TestHelpers.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/6/23.
//

import TodoiOS
import UIKit

extension TodoCell {
    var taskText: String? {
        taskTextView.text
    }
    
    func simulateCompleteAction() {
        radioButton.simulateTouchesBegan()
    }
    
    func simulateDeleteAction() {
        deleteButton.simulateTap()
    }
}
