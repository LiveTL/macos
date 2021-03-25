//
//  ChatMessageView.swift
//  macOS
//
//  Created by Andrew Glaze on 2/5/21.
//

import Kingfisher
import SwiftUI
import common

struct CozyChatView: View {
    @State var message: DisplayableMessage
    @State var textColor = Color.primary
    @State var timestamps = SettingsServices().timestamps
    
    var body: some View {
        VStack(alignment: .leading) {
            getEmojiText(message)
                .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 5)
                .foregroundColor(textColor)
            HStack {
                Text(message.displayAuthor)
                    .lineLimit(1)
                    .padding(.leading, 5)
                    .foregroundColor(getAuthorColor(message.authorTypes, defaultColor: textColor))
                if message.authorTypesThumbnails.first != nil {
                    ForEach(message.authorTypesThumbnails, id: \.self) { image in
                        KFImage(image)
                            .resizable()
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                    }
                }
                if message.superChat != nil {
                    Text(message.superChat!.amount)
                        .font(.headline)
                        .foregroundColor(textColor)
                }
                Spacer()
                if timestamps {
                    Text(String(message.displayTimestamp))
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .layoutPriority(1)
                        .padding(.horizontal, 5)
                    // .foregroundColor(textColor)
                }
                
            }
        }
        .background(stringToColor(message.superChat?.color) ?? Color.clear)
        .onAppear {
            if message.superChat != nil {
                textColor = Color.black
            }
        }
    }

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
 struct ChatMessageView_Previews: PreviewProvider {
     static var previews: some View {
         ChatMessageView()
     }
 }
 */
