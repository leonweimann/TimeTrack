//
//  View+IssueManager.swift
//  TimeTrack
//
//  Created by Leon Weimann on 05.10.24.
//

import SwiftUI

extension View {
    func attachIssueManager(_ manager: IssueManager) -> some View {
        @Bindable var manager = manager
        return self
            .environment(manager)
            .alert(isPresented: $manager.errorExists) {
                Alert(
                    title: Text("An error occurred"),
                    message: Text(manager.currentError?.localizedDescription ?? "Unknown error"),
                    dismissButton: .cancel(Text("Ok"))
                )
            }
    }
}
