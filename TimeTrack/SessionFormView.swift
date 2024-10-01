//
//  SessionFormView.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

struct SessionFormView: View {
    @Binding var session: Session
    var onCreate: (Session) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Session's name", text: $session.name)
            }
            
            Picker(selection: $session.type) {
                ForEach(SessionType.allCases, id: \.self) { type in
                    Text(type.title)
                }
            } label: {
                Label("Session Type", systemImage: "flag")
            }
            
            Section {
                createButton
            }
        }
        .navigationTitle("Create new session")
        .toolbar { toolbar }
    }
}

// MARK: -

extension SessionFormView {
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            cancelButton
                .labelStyle(.titleOnly)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            createButton
        }
    }
    
    private var cancelButton: some View {
        Button(role: .cancel, action: cancel) {
            Label("Cancel", systemImage: "xmark")
        }
    }
    
    private var createButton: some View {
        Button(action: create) {
            Label("Create new session", systemImage: "calendar.badge.plus")
        }
    }
}

// MARK: -

extension SessionFormView {
    private func cancel() {
        dismiss()
    }
    
    private func create() {
        onCreate(session)
        dismiss()
    }
}

#Preview {
    @Previewable @State var session = Session.template()
    NavigationStack {
        SessionFormView(session: $session) { _ in }
    }
}
