//
//  EventStoreManager+FullAccess.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit

extension EventStoreManager {
//    var store: EKEventStore {
//        datastore.eventStore
//    }
    
    func setupEventStore() async throws {
        let response = try await datastore.verifyAuthorizationStatus()
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        
        if response {
            // Load events?
        }
    }
}
