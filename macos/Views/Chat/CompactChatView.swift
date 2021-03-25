//
//  CompactChatView.swift
//  macos
//
//  Created by Andrew Glaze on 2/9/21.
//

import Kingfisher
import SwiftUI
// import Combine
import common

struct CompactChatView: View {
    @State var message: DisplayableMessage
    @State var textColor = Color.primary
    @State var timestamps = SettingsServices().timestamps

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(message.displayAuthor)
                        .lineLimit(1)
                        .foregroundColor(getAuthorColor(message.authorTypes, defaultColor: textColor))
                    if message.superChat != nil {
                        Text(message.superChat!.amount)
                            .font(.headline)
                            .foregroundColor(textColor)
                    }
                }
                Group {
                    getEmojiText(message)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(textColor)
                }
                Spacer()
                if timestamps {
                    Text(message.displayTimestamp)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }.padding(.all, 2)
        }
        .background(stringToColor(message.superChat?.color) ?? Color.clear)
        .onAppear {
            if message.superChat != nil {
                textColor = Color.black
            }
        }
    }

    // Returns a Text() view with YTC emotes embedded in it
    func getEmojiText(_ item: DisplayableMessage) -> Text {
        var fullMessage = Text("")
        for m in item.displayMessage {
            switch m {
            case .text(let s):
                fullMessage = fullMessage + Text(s)
            case .emote(let u):
                KingfisherManager.shared.retrieveImage(with: u) { r in
                    switch r {
                    case .success(let value):
                        fullMessage = fullMessage + Text("\(Image(nsImage: value.image).resizable())")
                    case .failure:
                        print("Emote Error!")
                    }
                }
            }
        }
        return fullMessage
    }
}

/*
 struct CompactChatView_Previews: PreviewProvider {
     static var previews: some View {
         CompactChatView()
     }
 }
 */
