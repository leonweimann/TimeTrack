//
//  SessionError.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import Foundation

enum SessionError: Error {
    case notFinished
    case alreadyFinished
    case creationFailure(CreationFailure)
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFinished:
            return NSLocalizedString("Session is not finished yet.", comment: "Not finished")
        case .alreadyFinished:
            return NSLocalizedString("Session is already finished yet.", comment: "Already finished")
        case .creationFailure(let failure):
            return NSLocalizedString("Session could not be created due to \(failure.rawValue)", comment: "Creation failed")
        }
    }
}
