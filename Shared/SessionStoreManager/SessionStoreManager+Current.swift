//
//  SessionStoreManager+Current.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import Foundation

extension SessionStoreManager {
    var currents: [Session] {
        sessions
            .filter { $0.isCurrent }
            .sorted { $1.startDate < $0.startDate }
    }
    
    func createSession(_ session: Session) throws {
        guard session.isCurrent else { throw SessionError.alreadyFinished }
        sessions.append(session)
    }
    
    func updateSession(_ session: Session) throws {
        guard session.isCurrent else { throw SessionError.alreadyFinished }
        try mutateSession(for: session.id) { savedSession in
            savedSession = session
        }
    }
    
    func finishSession(_ sessionID: Session.ID) throws {
        try mutateSession(for: sessionID) { session in
            guard session.isCurrent else { throw SessionError.alreadyFinished }
            
            // TODO: ...
            // ?
            try session.endNow()
        }
    }
}
