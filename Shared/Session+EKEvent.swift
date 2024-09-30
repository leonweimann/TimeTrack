//
//  Session+EKEvent.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

import EventKit

extension Session {
    func event(store: EKEventStore, calendar: EKCalendar? = nil) throws -> EKEvent {
        guard isCurrent else { throw SessionError.notFinished }
        let newEvent = EKEvent(self, eventStore: store, calendar: calendar)
        return newEvent
    }
}
