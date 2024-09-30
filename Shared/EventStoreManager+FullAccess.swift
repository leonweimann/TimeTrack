//
//  EventStoreManager+FullAccess.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

@preconcurrency import EventKit

extension EventStoreManager {
    func setupEventStore() async throws {
        let response = try await datastore.verifyAuthorizationStatus()
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        
        if response {
            await loadEvents()
        }
    }
    
    func loadEvents() async {
        let events = await datastore.fetchEvents()
        self.events = events
    }
    
    func removeEvent(_ event: EKEvent) async throws {
        try await datastore.removeEvent(event)
    }
    
    func addEvent(_ event: EKEvent) async throws {
        try await datastore.addEvent(event)
    }
}
