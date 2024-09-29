//
//  EventDataStore+FullAccess.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit

extension EventDataStore {
    var isFullAccessAuthorized: Bool {
        EKEventStore.authorizationStatus(for: .event) == .fullAccess
    }
    
    func requestFullAccess() async throws -> Bool {
        try await eventStore.requestFullAccessToEvents()
    }
    
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            return try await requestFullAccess()
        case .restricted:
            throw EventStoreError.restricted
        case .denied:
            throw EventStoreError.denied
        case .fullAccess:
            return true
        case .writeOnly:
            throw EventStoreError.upgrade
        @unknown default:
            throw EventStoreError.unknown
        }
    }
    
    func fetchEvents() -> [EKEvent] {
        guard isFullAccessAuthorized else { return [] }
        let now = Date.now
        let predicate = eventStore.predicateForEvents(withStart: now.yesterday, end: now, calendars: nil)
        return eventStore.events(matching: predicate)
    }
    
    private func removeEvent(_ event: EKEvent) throws {
        try eventStore.remove(event, span: .thisEvent, commit: false)
    }
    
    func removeEvents(_ events: [EKEvent]) throws {
        do {
            try events.forEach { event in
                try removeEvent(event)
            }
            try eventStore.commit()
        } catch {
            eventStore.reset()
            throw error
        }
    }
    
    func addEvent(_ event: EKEvent) throws {
        try eventStore.save(event, span: .thisEvent)
    }
}
