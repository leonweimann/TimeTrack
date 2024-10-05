//
//  SessionStoreManager+Access.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

extension SessionStoreManager {
    func mutateSession(for sessionID: Session.ID, completion: @escaping (inout Session) throws -> ()) throws {
        let index = try index(for: sessionID)
        var session = sessions[index]
        try completion(&session)
        sessions[index] = session
    }
    
    func session(for sessionID: Session.ID) throws -> Session {
        let index = try index(for: sessionID)
        return sessions[index]
    }
    
    private func index(for sessionID: Session.ID) throws -> [Session].Index {
        guard let index = sessions.firstIndex(where: { $0.id == sessionID }) else { throw SessionError.notFound }
        return index
    }
    
    func getBinding(to sessionWithID: Session.ID) throws -> Binding<Session> {
        let index = try index(for: sessionWithID)
        return Binding {
            self.sessions[index]
        } set: {
            self.sessions[index] = $0
        }
    }
}
