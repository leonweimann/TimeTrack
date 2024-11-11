//
//  Home.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

struct Home: View {
    @Environment(IssueManager.self) private var issueManager
    
    @Environment(SessionStoreManager.self) private var sessionManager
    @State private var selection: Session.ID?
    
    @State private var presentSessionFormSheet = false
    @State private var formSession: Session?
    
    var body: some View {
        NavigationStack {
            Group {
                if sessionManager.sessions.isEmpty {
                    noSessionsView
                } else {
                    List {
                        currentsSession
                            .listSectionSpacing(.compact)
                        
                        favoritesSection
                        
                        recentsSession
                    }
                    .toolbar { toolbar }
                }
            }
            .navigationTitle("TimeTrack")
            .sheet(isPresented: $presentSessionFormSheet, onDismiss: onSessionFormSheetDismiss) { sessionFormSheetView }
            .onChange(of: formSession != nil) { presentSessionFormSheet = $1 } // TODO: Maintain to extra func
            .onAppear { selection = sessionManager.currents.first?.id } // TODO: Maintain to extra func
        }
    }
}

// MARK: -

extension Home {
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) { // TODO: Maybe something like in Things is nicer?
            createSessionButton
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
    
    @ViewBuilder
    private var currentsSession: some View {
        if sessionManager.currents.isEmpty {
            createSessionButton
        } else {
            Section {
                currentsComponent
            } header: {
                currentsHeader
            }
            
            currentDetailSelector
        }
    }
    
    private var currentsHeader: some View {
        HStack {
            Text("Current Sessions")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            createSessionButton
                .labelStyle(.iconOnly)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
    
    private var currentDetailSelector: some View {
        Picker(selection: $selection) {
            ForEach(sessionManager.currents) { current in
                Text(current.title)
                    .tag(current.id)
            }
        } label: {
            Label("Show more", systemImage: "text.line.last.and.arrowtriangle.forward")
                .fontWeight(.semibold)
        }
        .pickerStyle(.navigationLink)
        .font(.callout)
        .lineLimit(1)
    }
    
    // TODO: ..
    @ViewBuilder
    private var favoritesSection: some View {
        if true {
            Section("Favorites") {
                ContentUnavailableView("No favorites yet.", systemImage: "star.slash.fill")
            }
        }
    }
    
    @ViewBuilder
    private var recentsSession: some View {
        if !sessionManager.sessions.isEmpty {
            Section {
                
                // TODO: Recents on next nav page. Maybe there a nice list with favs, presets etc.?
                // What's missing?
                NavigationLink {
                    // TODO: Custom View...
                    recentsDestinationTemp
                } label: {
                    Label("Recent sessions", systemImage: "clock")
                }
            } header: {
                recentsHeader
            }
        }
    }
    
    private var recentsHeader: some View {
        HStack {
            Text("Recent Sessions")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(sessionManager.recents.count, format: .number)
                .contentTransition(.numericText())
                .animation(.smooth, value: sessionManager.recents.count)
        }
    }
    
    private var recentsDestinationTemp: some View {
        // TODO: Sort into sections by time / maybe also date (currently recents only involve last 24h in calendar..)
        List(sessionManager.recents) { recent in
            // Functions: --stop--, restore, delete (template), --edit--, save as template, create (from template..)
            // Instead templates -> favs?
            Button {
                
            } label: {
                Text(recent.title)
            }
            .tint(.primary)
        }
    }
    
    private var sessionFormSheetView: some View {
        NavigationStack {
            if let id = formSession?.id {
                let isNew = !sessionManager.sessionExists(id)
                
                SessionFormView(
                    isNew ? "Create new Session" : "Edit a session",
                    session: Binding { formSession ?? .template() } set: { formSession = $0 },
                    onCreate: isNew ? sessionManager.createSession : sessionManager.updateSession
                )
            }
        }
    }
}

// MARK: -

extension Home {
    private var currentsComponent: some View { // TODO: Currently no animation / scroll even visible, so this all is unbelievable unnecessary.
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
            
            editSessionButton(session)
        } label: {
            SessionDetailView(session: session)
        }
        .foregroundStyle(Color.primary)
        .containerRelativeFrame(.horizontal)
    }
}

// MARK: -

extension Home {
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
    
    private func editSessionButton(_ session: Session) -> some View {
        Button {
            editSession(session)
        } label: {
            Label("Edit Session", systemImage: "pencil")
        }
    }
}

// MARK: -

extension Home {
    private func createSession() {
        formSession = .template()
    }
    
    private func stopSession() {
        guard let selection else { return }
        issueManager.withError {
            try sessionManager.finishSession(selection)
        }
    }
    
    private func editSession(_ session: Session) {
        formSession = session
    }
    
    private func onSessionFormSheetDismiss() {
        formSession = nil
    }
}

#Preview(traits: .sessionStore(), .issueManager) {
    Home()
}
