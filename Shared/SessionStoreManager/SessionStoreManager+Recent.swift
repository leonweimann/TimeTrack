//
//  SessionStoreManager+Recent.swift
//  TimeTrack
//
//  Created by Leon Weimann on 11.11.24.
//

import Foundation

extension SessionStoreManager {
    var recents: [Session] {
        sessions
            .filter { !$0.isCurrent }
            .sorted { $1.startDate < $0.startDate }
    }
}
