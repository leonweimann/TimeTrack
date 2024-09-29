//
//  SessionError.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import Foundation

enum SessionError: Error {
    case notFinished
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFinished:
            return NSLocalizedString("Session is not finished yet.", comment: "Not finished")
        }
    }
}
