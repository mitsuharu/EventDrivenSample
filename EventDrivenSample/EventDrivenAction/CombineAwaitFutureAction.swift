//
//  CombineAwaitFutureAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation
import Combine

final class CombineAwaitFutureAction: EventDrivenActionProtocol {
    var observeHandler: Handler? = nil
    
    private var task: Task<(), Never>? = nil
    private let subject = PassthroughSubject<EventMessage, Never>()
    private var subscriptions = [AnyCancellable]()
    
    init() {
        start()
    }
    
    deinit {
        stop()
    }
    
    private func start()  {
        task = Task {
            while true {
                let value = await self.observe().value
                self.observeHandler?(value)
            }
        }
    }
    
    private func observe() -> Future<EventMessage, Never>{
        Future { [weak self] promise in
            guard let self else { return }
            self.subject.sink {
                promise(.success($0))
            }.store(in: &self.subscriptions)
        }
    }
    
    private func stop() {
        task?.cancel()
        task = nil
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        observeHandler = nil
    }
    
    func put(message: EventMessage) {
        subject.send(message)
    }
}


