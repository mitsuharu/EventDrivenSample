//
//  EventDrivenAction.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import Foundation

protocol EventDrivenActionProtocol {
    typealias EventMessage = String
    typealias Handler = (EventMessage) -> Void
        
    func put(message: EventMessage)
    var observeHandler: Handler? { get set }
}
