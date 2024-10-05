//
//  IssueManager.swift
//  TimeTrack
//
//  Created by Leon Weimann on 05.10.24.
//

import Foundation
import Observation

@Observable @MainActor
final class IssueManager {
    private(set) var currentError: (any Error)?
    
    var errorExists: Bool {
        get { currentError != nil }
        set { currentError = nil }
    }
}
