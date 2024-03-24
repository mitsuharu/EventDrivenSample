//
//  ConcurrencyAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation

final class ConcurrencyAction: EventDrivenActionProtocol {
    var observeHandler: Handler? = nil
    
    private var task: Task<Void, Never>? = nil
    private var handler: ((EventMessage) -> Void)? = nil
    
    private var stream: AsyncStream<EventMessage> {
        AsyncStream { [weak self] continuation in
            self?.handler = { eventMessage in
                continuation.yield(eventMessage)
            }
            continuation.onTermination = { @Sendable [weak self] _ in
                self?.stop()
            }
        }
    }
    
    init() {
        start()
    }
    
    deinit {
        stop()
    }
        
    private func start() {
        task = Task {
            for await value in stream {
                self.observeHandler?(value)
            }
        }
    }
    
    private func stop(){
        task?.cancel()
        task = nil
        observeHandler = nil
    }
    
    func publish(message: EventMessage) {
        self.handler?(message)
    }
}

