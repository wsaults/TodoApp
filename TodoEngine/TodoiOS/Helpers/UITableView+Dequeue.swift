//
//  UITableView+Dequeue.swift
//  TodoiOS
//
//  Created by Will Saults on 2/7/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
    
    func register(_ cell: UITableViewCell.Type) {
        let identifier = String(describing: cell.self)
        self.register(cell.self, forCellReuseIdentifier: identifier)
    }
}
