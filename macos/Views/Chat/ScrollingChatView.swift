//
//  ScrollingChatView.swift
//  macOS
//
//  Created by Andrew Glaze on 2/5/21.
//

import SwiftUI
import common

struct ScrollingChatView: View {
    @State var model: WatchModel
    @State var messages: [DisplayableMessage] = []

    var body: some View {
        Group {
            if !messages.isEmpty {
                List(messages, id: \.sortTimestamp) { message in
                    CompactChatView(message: message)
                        .flippedUpsideDown()
                        .cornerRadius(10)
                }
                .id(UUID())
                .flippedUpsideDown()
            } else {
                Text("loading-chat").padding()
            }

        }.onReceive(model.chatDriver.publisher) { m in
            self.messages = m
            print(m)
        }
    }
}

struct ScrollingChatView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingChatView(model: WatchModel(AppServices()))
    }
}
