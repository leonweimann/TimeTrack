//
//  SessionDetailView.swift
//  TimeTrack
//
//  Created by Leon Weimann on 30.09.24.
//

import SwiftUI

struct SessionDetailView: View {
    init(session: Session) {
        self.session = session
        self._model = .init(initialValue: .init(shouldAttach: session.isCurrent))
    }
    
    private var session: Session
    @State private var model: ViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                if let timer = model.timer {
                    Text(model.now, format: .timer(countingUpIn: session.startDate ..< model.now))
                        .onReceive(timer) { newNow in
                            model.now = newNow
                        }
                } else if let endDate = session.endDate {
                    Text(model.now, format: .timer(countingUpIn: session.startDate ..< endDate))
                }
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(.tint)
            .contentTransition(.numericText())
            .animation(.smooth, value: model.now)
            
            HStack {
                Text(session.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(session.type.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .onChange(of: session) { oldValue, newValue in
            model = .init(shouldAttach: newValue.isCurrent)
        }
    }
}

#Preview {
    NavigationStack {
        List {
            Section {
                SessionDetailView(session: .sessionStartMock)
            }
            
            Section {
                SessionDetailView(
                    session: {
                            var session = Session.sessionStartMock
                            session.startDate.addTimeInterval(-90)
                            return session
                        }()
                )
            }
            
            SessionDetailView(session: .sessionStartEndMock)
        }
        .navigationTitle("SessionDetailView")
    }
}
