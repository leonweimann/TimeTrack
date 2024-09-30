//
//  Session+Type.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

import Foundation

enum SessionType: Int, Hashable, CaseIterable, Identifiable {
    var id: Int { rawValue }
    
    case personal = 0
    case work = 1
    
    var title: String {
        NSLocalizedString(
            String(describing: self).capitalized,
            comment: "A session type"
        )
    }
}
