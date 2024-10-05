//
//  IssueManagerPreviewModifier.swift
//  TimeTrack
//
//  Created by Leon Weimann on 05.10.24.
//

import SwiftUI

fileprivate struct IssueManagerPreviewModifier: PreviewModifier {
    static func makeSharedContext() async throws -> IssueManager {
        return IssueManager()
    }
    
    func body(content: Content, context: IssueManager) -> some View {
        content
            .attachIssueManager(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var issueManager: Self {
        .modifier(IssueManagerPreviewModifier())
    }
}
