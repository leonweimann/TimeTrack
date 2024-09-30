//
//  Session+Date.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit

extension Session {
    var startAtDate: Date {
        TimeInterval(startAt).toTodayDate
    }
    
    var endAtDate: Date {
        guard let endAt else { return startAtDate }
        return TimeInterval(endAt).toTodayDate
    }
}

extension Session {
    func event(store: EKEventStore, calendar: EKCalendar? = nil) throws -> EKEvent {
        guard isCurrent else { throw SessionError.notFinished }
        let newEvent = EKEvent(self, eventStore: store, calendar: calendar)
        return newEvent
    }
}
