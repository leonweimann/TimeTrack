//
//  SessionStorePreviewModifier.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import SwiftUI

fileprivate struct SessionStorePreviewModifiers {
    private init() { }
    
    struct Empty: PreviewModifier {
        static func makeSharedContext() async throws -> SessionStoreManager {
            let datastore = EventDataStore()
            let manager = SessionStoreManager(datastore: datastore)
            return manager
        }
        
        func body(content: Content, context: SessionStoreManager) -> some View {
            content
                .environment(context)
        }
    }
    
    struct Filled: PreviewModifier {
        static func makeSharedContext() async throws -> SessionStoreManager {
            let datastore = EventDataStore()
            let manager = SessionStoreManager(datastore: datastore)
            
            let sampleSessions: [Session] = [
                .sessionStartMock,
                .init(type: .personal, name: "Cook some nice food", startDate: .now.addingTimeInterval(-60 * 37)),
                .sessionStartEndMock,
                .init(type: .work, name: "Code some Preview.ViewTraits", startDate: .now.addingTimeInterval(-60 * 60 * 3), endDate: .now.addingTimeInterval(-60 * 42))
            ]
            
            manager.sessions = sampleSessions
            
            return manager
        }
        
        func body(content: Content, context: SessionStoreManager) -> some View {
            content
                .environment(context)
        }
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static func sessionStore(isEmpty: Bool = false) -> Self {
        isEmpty ? .modifier(SessionStorePreviewModifiers.Empty()) : .modifier(SessionStorePreviewModifiers.Filled())
    }
}
