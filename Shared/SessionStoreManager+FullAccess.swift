//
//  SessionStoreManager+FullAccess.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

@preconcurrency import EventKit

extension SessionStoreManager {
    func setupSessionStore() async throws {
        let response = try await datastore.verifyAuthorizationStatus()
        if response {
            try await loadSessions()
        }
    }
    
    func loadSessions() async throws {
        let sessions = try await datastore.fetchEvents()
            .compactMap { event in
                do {
                    return try Session(event: event)
                } catch {
                    if case SessionError.creationFailure(_) = error {
                        throw error
                    }
                    
                    return nil
                }
            }
        
        self.sessions = sessions
    }
    
    func addSession(_ session: Session) async throws {
        try await datastore.addEvent(session.event(store: datastore.eventStore))
        sessions.append(session)
    }
    
    func removeSession(_ session: Session) async throws {
        try await datastore.removeEvent(session.event(store: datastore.eventStore))
        sessions.removeAll { session.isIdentical(to: $0) }
    }
}
