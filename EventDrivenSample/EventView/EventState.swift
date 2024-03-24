//
//  EventState.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation

@Observable
final class EventState {
    var message: String?
    @ObservationIgnored var action: any EventDrivenActionProtocol
    
    private init(action: any EventDrivenActionProtocol) {
        self.action = action
        self.action.observeHandler = { [weak self] in
            self?.message = $0
        }
    }
    
    static func NotificationCenter() -> EventState {
        let action = NotificationCenterAction()
        let state = EventState(action: action)
        return state
    }
    
    static func Combine() -> EventState {
        let action = CombineAction()
        let state = EventState(action: action)
        return state
    }
    
    static func CombineAwait() -> EventState {
        let action = CombineAwaitAction()
        let state = EventState(action: action)
        return state
    }
    
    static func Concurrency() -> EventState {
        let action = ConcurrencyAction()
        let state = EventState(action: action)
        return state
    }
    
    static func ConcurrencyBackDeployed() -> EventState {
        let action = ConcurrencyBackDeployedAction()
        let state = EventState(action: action)
        return state
    }
}

extension EventState {
    func publish(message: String) {
        print("publish \(message)")
        action.publish(message: message)
    }
}

