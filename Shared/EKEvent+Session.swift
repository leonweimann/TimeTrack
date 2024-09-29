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
        self.startDate = session.startAtDate
        self.endDate = session.endAtDate
        self.notes = String(describing: session.type)
        
        self.timeZone = TimeZone.current
    }
}
