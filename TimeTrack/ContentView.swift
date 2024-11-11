//
//  ContentView.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import SwiftUI

struct ContentView: View {
    @State private var issueManager = IssueManager()
    @State private var sessionManager = SessionStoreManager()

    // setupSessionStore, app splash screen, app welcome, etc.?
    var body: some View {
        Home()
            .environment(sessionManager)
            .attachIssueManager(issueManager)
            .task {
                await issueManager.withError {
                    try await sessionManager.setupSessionStore()
                }
            }
    }
}

#Preview {
    ContentView()
}
