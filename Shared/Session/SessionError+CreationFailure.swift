//
//  SessionError+CreationFailure.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

import Foundation

extension SessionError {
    enum CreationFailure: String {
        case notSessionEvent = "The provided event is not a session event"
        case noID = "No ID was provided"
        case noName = "No name was provided"
    }
}
