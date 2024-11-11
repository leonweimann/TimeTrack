//
//  SessionDetailViewModel.swift
//  TimeTrack
//
//  Created by Leon Weimann on 01.10.24.
//

import Combine
import Foundation
import Observation

extension SessionDetailView {
    @Observable @MainActor
    final class ViewModel {
        init(shouldAttach: Bool) {
            if shouldAttach {
                attachTimer()
            }
        }
        
        var now = Date.now
        var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
        
        func attachTimer() {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        
        /*View never detach, since it will be rerendered
          completely on every session model change. So if it needs
          to be 'detached', it basically won't be attached ever.
         
        func detachTimer() {
            timer?.upstream.connect().cancel()
            timer = nil
        }*/
    }
}
