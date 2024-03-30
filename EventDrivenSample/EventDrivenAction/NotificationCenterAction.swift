//
//  NotificationCenterAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation

final class NotificationCenterAction: EventDrivenActionProtocol  {
    var observeHandler: Handler? = nil
    
    init() {
        start()
    }
    
    deinit {
        stop()
    }
    
    private func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(observe),
            name: .eventAction,
            object: nil
        )
    }
    
    private func stop() {
        NotificationCenter.default.removeObserver(self)
        observeHandler = nil
    }
    
    func put(message: EventMessage) {
        NotificationCenter.default.post(name: .eventAction, object: message)
    }
        
    @objc private func observe(notification: Notification) {
        guard let message = notification.object as? String else { return }
        self.observeHandler?(message)
    }
}

fileprivate extension Notification.Name {
    static let eventAction = Notification.Name("eventAction")
}
