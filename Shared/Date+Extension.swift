//
//  Date+Extension.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import Foundation

extension Date {
    var yesterday: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
}
