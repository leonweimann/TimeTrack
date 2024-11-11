//
//  EKEvent+Session.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit

extension EKEvent {
    convenience init(_ session: Session, eventStore: EKEventStore, calendar: EKCalendar?) {
        self.init(eventStore: eventStore)
        self.title = session.title
        self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
        self.startDate = session.startDate
        self.endDate = session.endDate ?? session.startDate
        self.notes = session.type.title
        
        self.url = URL(string: "session-\(session.id)")
        
        self.timeZone = TimeZone.current
    }
}
