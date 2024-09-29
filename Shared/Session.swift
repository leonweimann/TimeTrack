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
    
    var startAt: Int
    var endAt: Int?
    
    var isCurrent: Bool { endAt != nil }
    
    init(id: String = UUID().uuidString, type: SessionType, name: String, startAt: Int) {
        self.id = id
        self.type = type
        self.name = name
        self.startAt = startAt
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
    static var sessionMock: Session {
        Session(type: .personal, name: "Ironing", startAt: 43_200)
    }
}
