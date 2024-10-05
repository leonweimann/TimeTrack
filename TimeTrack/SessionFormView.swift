//
//  SessionFormView.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

struct SessionFormView: View {
    init(_ title: String = "Create new session", session: Binding<Session>, onCreate: @escaping (Session) throws -> ()) {
        self.title = title
        self._session = session
        self.onCreate = onCreate
    }
    
    private let title: String
    @Binding private var session: Session
    private let onCreate: (Session) throws -> ()
    
    @Environment(IssueManager.self) private var issueManager
    @Environment(\.dismiss) private var dismiss
    
    private var isFormValid: Bool {
        !session.name.isEmpty
    }
    
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
        .navigationTitle(title)
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
            if isFormValid {
                Label(title, systemImage: "calendar.badge.plus")
            } else {
                Label(title, systemImage: "calendar.badge.plus")
                    .foregroundStyle(.secondary)
            }
        }
        .disabled(!isFormValid)
    }
}

// MARK: -

extension SessionFormView {
    private func cancel() {
        dismiss()
    }
    
    private func create() {
        issueManager.withError {
            try onCreate(session)
            dismiss()
        }
    }
}

#Preview {
    @Previewable @State var issueManager = IssueManager()
    @Previewable @State var session = Session.template()
    
    NavigationStack {
        SessionFormView(session: $session) { _ in }
    }
    .attachIssueManager(issueManager)
}
