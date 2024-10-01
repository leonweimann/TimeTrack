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
        guard let index = sessions.firstIndex(of: session) else { throw SessionError.notFound }
        sessions[index] = session
    }
    
    func finishSession(_ sessionID: Session.ID) throws {
        guard let session = sessions.first(where: { $0.id == sessionID }) else { throw SessionError.notFound }
        guard session.isCurrent else { throw SessionError.alreadyFinished }
        // TODO: ...
    }
}
