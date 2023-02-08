//
//  SharedTestHelpers.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

let anyDate = Date()
let anyNSError = NSError(domain: "any error", code: 0)

extension Date {
    func addHours(_ hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: Date())!
    }
    
    func addDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
    
    func inToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
}
