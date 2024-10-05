//
//  Session+EKEvent.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

import EventKit

extension Session {
    // TODO: SessionType is not handled!
    init(event: EKEvent) throws {
        guard
            let string = event.url?.absoluteString,
            string.hasPrefix("session-")
        else {
            throw SessionError.creationFailure(.notSessionEvent)
        }
        
        guard let id = string.split(separator: "-").last else {
            throw SessionError.creationFailure(.noID)
        }
        
        guard let index = event.title.firstIndex(of: " ") else {
            throw SessionError.creationFailure(.noName)
        }
        let name = event.title.suffix(from: index)
        
        let endDate = (event.endDate == event.startDate) ? nil : event.endDate

        self.init(id: String(id), type: .personal, name: String(name), startDate: event.startDate, endDate: endDate)
    }
}

extension Session {
    func event(store: EKEventStore, calendar: EKCalendar? = nil) throws -> EKEvent {
        guard isCurrent else { throw SessionError.notFinished }
        let newEvent = EKEvent(self, eventStore: store, calendar: calendar)
        return newEvent
    }
}
