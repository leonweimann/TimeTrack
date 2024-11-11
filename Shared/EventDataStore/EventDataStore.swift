//
//  EventDataStore.swift
//  TimeTrack
//
//  Created by Leon Weimann on 29.09.24.
//

@preconcurrency import EventKit

actor EventDataStore {
    let eventStore: EKEventStore
    
    init() {
        self.eventStore = EKEventStore()
    }
}
