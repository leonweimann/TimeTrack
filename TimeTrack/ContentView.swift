//
//  ContentView.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import SwiftUI

struct ContentView: View {
    @State private var sessionManager = SessionStoreManager()

    // setupSessionStore, app splash screen, app welcome, etc.?
    var body: some View {
        Home()
            .environment(sessionManager)
    }
}

#Preview {
    ContentView()
}
