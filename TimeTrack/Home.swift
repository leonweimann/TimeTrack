//
//  Home.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

struct Home: View {
    @Environment(SessionStoreManager.self) private var sessionManager
    @State private var selection: Session.ID?
    
    @State private var newSession: Session?
    
    var body: some View {
        NavigationStack {
            Group {
                if sessionManager.sessions.isEmpty {
                    noSessionsView
                } else {
                    List {
                        currentSessions
                        
                        recentSessions
                    }
                    .toolbar { toolbar }
                }
            }
            .navigationTitle("TimeTrack")
            .sheet(item: $newSession, onDismiss: cancelSessionCreation) { _ in
                newSessionFormSheet
            }
            .onAppear {
                selection = sessionManager.currents.first?.id
            }
        }
    }
}

// MARK: -

extension Home {
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) { // TODO: Is bottomBar really the way to go?
            HStack {
                createSessionButton
                stopSessionButton
            }
        }
    }
    
    private var noSessionsView: some View {
        ContentUnavailableView {
            Label("You don't have any current session yet.", systemImage: "calendar.badge.exclamationmark")
        } description: {
            Text("No worries, you can start your first now!")
        } actions: {
            createSessionButton
        }
    }
    
    private var currentSessions: some View {
        Section {
            if sessionManager.currents.isEmpty {
                createSessionButton
            } else {
                currentsComponent
            }
        } header: {
            currentSessionsHeader
        }
    }
    
    private var recentSessions: some View {
        Section {
            // FILTER ...
            ForEach(sessionManager.sessions) { session in
                // Functions: --stop--, restore, delete, --edit--, save as template
                Button {
                    
                } label: {
                    Text(session.title)
                }
                .tint(.primary)
            }
        } header: {
            recentsHeader
        }
    }
    
    @ViewBuilder
    private var newSessionFormSheet: some View {
        if newSession != nil {
            NavigationStack {
            }
        }
    }
    
    private var createSessionButton: some View {
        Button(action: createSession) {
            Label("Start a new Session", systemImage: "plus")
        }
    }
    
    private var stopSessionButton: some View {
        Button(role: .destructive, action: stopSession) {
            Label("Stop Session", systemImage: "stop")
        }
    }
    
    private var editSessionButton: some View {
        Button(action: editSession) {
            Label("Edit Session", systemImage: "pencil")
        }
    }
    
    private var currentsComponent: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(sessionManager.currents) { current in
                    CurrentSessionDetailCell(session: current)
                        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.8, anchor: .bottom)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $selection)
        .scrollIndicators(.hidden)
        .scrollDisabled(sessionManager.currents.count < 2)
        .scrollDisabled(true)
        .listRowInsets(.init())
        .contentMargins(.vertical, 12, for: .scrollContent)
        .contentMargins(.horizontal, 20, for: .scrollContent)
        .animation(.smooth, value: selection)
    }
    
    private func CurrentSessionDetailCell(session: Session) -> some View {
        Menu {
            stopSessionButton
            
            Divider()
            
            editSessionButton
        } label: {
            SessionDetailView(session: session)
        } 
        .foregroundStyle(Color.primary)
        .containerRelativeFrame(.horizontal)
    }
    
    private var currentSessionsHeader: some View {
        HStack {
            Text("Current Sessions")
            
            Spacer()
            
            createSessionButton
                .labelStyle(.iconOnly)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
    
    private var recentsHeader: some View {
        HStack {
            Text("Recent Sessions")
            
            Spacer()
            
            Text(sessionManager.sessions.count, format: .number)
                .contentTransition(.numericText())
                .animation(.smooth, value: sessionManager.sessions.count)
        }
    }
}

// MARK: -

extension Home {
    private func createSession() {
        newSession = .template()
    }
    
    private func cancelSessionCreation() {
        newSession = nil
    }
    
    private func stopSession() {
        guard let selection else { return }
        try? sessionManager.finishSession(selection) // TODO: error handling
    }
    
    private func editSession() { // TODO: ...

    }
}

#Preview(traits: .sessionStore()) {
    Home()
}
