//
//  ScrollingTlView.swift
//  macOS
//
//  Created by Andrew Glaze on 2/5/21.
//

import SwiftUI
import common

struct ScrollingTlView: View {
    @State var model: WatchModel
    @State var messages: [DisplayableMessage] = []

    var body: some View {
        Group {
            if !messages.isEmpty {
                List(messages, id: \.sortTimestamp) { message in
                    CozyChatView(message: message)
                        .cornerRadius(10)
                        .flippedUpsideDown()
                }
                .id(UUID())
                .flippedUpsideDown()
            } else {
                Text("loading-tl")
            }

        }.onReceive(model.translatedChat.asDriver().publisher) { m in
            self.messages = m
        }
    }
}

struct ScrollingTlView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingTlView(model: WatchModel(AppServices()))
    }
}
