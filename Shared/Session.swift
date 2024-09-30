//
//  Session.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit

struct Session: Hashable, Identifiable {
    let id: String
    
    var type: SessionType
    var name: String
    
    var startDate: Date
    var endDate: Date?
    
    var isCurrent: Bool { endDate != nil }
    
    init(id: String = UUID().uuidString, type: SessionType, name: String, startDate: Date, endDate: Date? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension Session {
    var title: String {
        (isCurrent ? "Current" : "Session") + name
    }
}

extension Session: Equatable {
    static func ==(lhs: Session, rhs: Session) -> Bool {
        lhs.id == rhs.id
    }
}

extension Session {
    static var sessionStartMock: Session {
        Session(type: .personal, name: "Ironing", startDate: Date.now)
    }
}
