//
//  IssueManager+Error.swift
//  TimeTrack
//
//  Created by Leon Weimann on 05.10.24.
//

import Foundation

extension IssueManager {
    func throwError(_ error: any Error) {
        handleThrownError(error)
    }
    
    func withError(_ completion: @escaping () throws -> ()) {
        do {
            try completion()
        } catch {
            handleThrownError(error)
        }
    }
    
    func withError(_ completion: @escaping () async throws -> ()) async {
        do {
            try await completion()
        } catch {
            handleThrownError(error)
        }
    }
    
    private func handleThrownError(_ error: any Error) {
        self.throwError(error)
        print("⚠️ Error occurred:", error.localizedDescription)
    }
}
