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
    
    var body: some View {
        NavigationStack {
            Group {
                if sessionManager.sessions.isEmpty {
                    noSessionsView
                } else {
                    List {
                        Section {
                            currentsComponent
                        } header: {
                            currentSessionsHeader
                        }
                        
                        Section {
                            ForEach(sessionManager.sessions) { session in
                                // Functions: stop, restore, delete, edit, save as template
                                Button {
//                                    current = nil
//                                    current = session
                                } label: {
                                    Text(session.title)
                                }
                                .tint(.primary)
                            }
                        } header: {
                            historyHeader
                        }
                    }
                    .toolbar { toolbar }
                }
            }
            .navigationTitle("TimeTrack")
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
        ToolbarItem(placement: .bottomBar) {
            HStack {
                createSessionButton
                
                Button {
                    guard !sessionManager.sessions.isEmpty else { return }
                    sessionManager.sessions.removeLast()
                } label: {
                    Image(systemName: "pause")
                        .frame(maxWidth: .infinity)
                }
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
    
    private var createSessionButton: some View {
        Button {
            sessionManager.sessions.append(
                Bool.random() ? .sessionStartMock : .sessionStartEndMock
            )
        } label: {
            Label("Start a new Session", systemImage: "plus")
        }
    }
    
    private var currentsComponent: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(sessionManager.currents) { current in
                    Button {
                        selection = current.id
                    } label: {
                        SessionDetailView(session: current)
                    }
                    .foregroundStyle(Color.primary)
                    .containerRelativeFrame(.horizontal)
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
        .animation(.smooth, value: selection)
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
    
    // FILTER ...
    private var historyHeader: some View {
        HStack {
            Text("Last Sessions")
            
            Spacer()
            
            Text(sessionManager.sessions.count, format: .number)
                .contentTransition(.numericText())
                .animation(.smooth, value: sessionManager.sessions.count)
        }
    }
}

#Preview(traits: .sessionStore()) {
    Home()
}
