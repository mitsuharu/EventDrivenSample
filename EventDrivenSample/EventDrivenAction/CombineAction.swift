//
//  CombineAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation
import Combine

final class CombineAction: EventDrivenActionProtocol {
    var observeHandler: Handler? = nil
    
    private let subject = PassthroughSubject<EventMessage, Never>()
    private var subscriptions = [AnyCancellable]()
    
    init() {
        start()
    }
    
    deinit {
        stop()
    }
    
    private func start() {
        subject.sink { [weak self] in
            self?.observeHandler?($0)
        }.store(in: &subscriptions)
    }
    
    private func stop() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        observeHandler = nil
    }
    
    func publish(message: EventMessage) {
        subject.send(message)
    }
}
