//
//  EventStoreManager.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import EventKit
import Observation

@Observable @MainActor
final class EventStoreManager {
    var events: [EKEvent]
    var authorizationStatus: EKAuthorizationStatus
    
    let datastore: EventDataStore
    
    init(store: EventDataStore = EventDataStore()) {
        self.datastore = store
        self.events = []
        self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
}
