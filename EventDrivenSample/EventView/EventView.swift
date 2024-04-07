//
//  EventView.swift
//  EventDrivenSample
//
//  Created by Mitsuharu Emoto on 2024/03/24.
//

import SwiftUI

struct EventView: View {
    
//    @State private var state = EventState.NotificationCenter()
//    @State private var state = EventState.Combine()
    @State private var state = EventState.CombineAwaitContinuation()
//    @State private var state = EventState.CombineAwaitFuture()
//    @State private var state = EventState.Concurrency()
//    @State private var state = EventState.ConcurrencyBackDeployed()

    
    var body: some View {
        Text("message is \(state.message ?? "none")")
        Button("publish") {
            let message = UUID().uuidString
            state.publish(message: message)
        }
    }
}

#Preview {
    EventView()
}
