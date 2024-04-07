//
//  CombineAwaitContinuationAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/04/07.
//

import Foundation
import Combine

final class CombineAwaitContinuationAction: EventDrivenActionProtocol {
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
                let value = await self.observe()
                self.observeHandler?(value)
            }
        }
    }
    
    private func receive(callback: @escaping (_ message: EventMessage) -> Void ){
        // 監視は一度限りで行い、検出後は破棄する
        // 破棄しないと withCheckedContinuation で多重呼出の扱いになりクラッシュする
        var cancellable: AnyCancellable? = nil
        cancellable = subject.sink {
            callback($0)
            cancellable?.cancel()
        }
    }
    
    private func observe() async -> EventMessage {
        return await withCheckedContinuation { continuation in
            receive { message in
                continuation.resume(returning: message)
            }
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


