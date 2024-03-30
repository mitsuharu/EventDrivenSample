//
//  ConcurrencyBackDeployedAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation

final class ConcurrencyBackDeployedAction: EventDrivenActionProtocol {
    var observeHandler: Handler? = nil
        
    private var task: Task<Void, Never>? = nil
    private let (stream, continuation) = AsyncStream.makeStream(of: EventMessage.self)
    
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
        continuation.finish()
        task?.cancel()
        observeHandler = nil
    }
    
    func put(message: EventMessage) {
        continuation.yield(message)
    }
}

