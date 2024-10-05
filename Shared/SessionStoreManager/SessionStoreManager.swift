//
//  SessionStoreManager.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

import Observation

@Observable @MainActor
final class SessionStoreManager {
    var sessions: [Session]
    
    let datastore: EventDataStore
    
    init(datastore: EventDataStore = EventDataStore()) {
        self.sessions = []
        self.datastore = datastore
    }
}
