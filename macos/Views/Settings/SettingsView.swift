//
//  SettingsView.swift
//  macos
//
//  Created by Andrew Glaze on 2/20/21.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults
import common
let services = AppServices()

struct SettingsView: View {
    var body: some View {
        TabView {
            TranslatorTabView().tabItem {
                Text("tl-tab")
                Image(systemName: "character.book.closed.ja")
            }.tag(1)
            AppearanceTabView().tabItem {
                Text("appearence-tab")
                Image(systemName: "paintbrush")
            }.tag(2)
        }.padding()
    }
}

struct TranslatorTabView: View {
    @ObservedObject var settings = SettingsServices()

    @State var newBlock: String = ""
    @State var newAdd: String = ""
    @State var isOn: Bool = true
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $settings.singleLanguage, label: Text("language-picker")) {
                Text("English").tag(TranslatedLanguageTag.en)
                Text("Japanese").tag(TranslatedLanguageTag.jp)
                Text("Spanish").tag(TranslatedLanguageTag.es)
                Text("Indonesian").tag(TranslatedLanguageTag.id)
                Text("Korean").tag(TranslatedLanguageTag.kr)
                Text("Chinese").tag(TranslatedLanguageTag.zh)
                Text("Russian").tag(TranslatedLanguageTag.ru)
                Text("French").tag(TranslatedLanguageTag.fr)
            }.frame(width: 200)
            Toggle(isOn: $isOn) {
                Text("mod-toggle")
            }.onChange(of: isOn, perform: { value in
                settings.modMessages = value
                settings.objectWillChange.send()
            }).onAppear {
                isOn = settings.modMessages
            }
            Text("user-filter-label")
            HStack {
                List {
                    Section(header: Text("allowed-tl")) {
                        ForEach(settings.alwaysUsers, id: \.self) { user in
                            HStack {
                                Text(user)
                                Spacer()
                                Button(action: {
                                    guard let elementIndex = settings.alwaysUsers.firstIndex(of: user) else {
                                        return
                                    }
                                    settings.alwaysUsers.remove(at: elementIndex)
                                    settings.objectWillChange.send()
                                }, label: {
                                    Text("-")
                                })
                            }
                        }
                    }
                }.listStyle(PlainListStyle())
                Divider()
                List {
                    Section(header: Text("blocked-tl")) {
                        ForEach(settings.neverUsers, id: \.self) { user in
                            HStack {
                                Text(user)
                                Spacer()
                                Button(action: {
                                    guard let elementIndex = settings.neverUsers.firstIndex(of: user) else {
                                        return
                                    }
                                    settings.neverUsers.remove(at: elementIndex)
                                    settings.objectWillChange.send()
                                }, label: {
                                    Text("-")
                                })
                            }
                        }
                    }
                }.listStyle(PlainListStyle())
            }.padding()
            HStack {
                TextField("add-tl", text: $newAdd)
                Button(action: {
                    settings.alwaysUsers.append(newAdd)
                    settings.objectWillChange.send()
                    newAdd = ""
                }, label: {
                    Text("+")
                })
            }
            HStack {
                TextField("remove-tl", text: $newBlock)
                Button(action: {
                    settings.neverUsers.append(newBlock)
                    settings.objectWillChange.send()
                    newBlock = ""
                }, label: {
                    Text("+")
                })
            }
        }.padding().frame(width: 400, height: 300, alignment: .center)
    }
}


struct AppearanceTabView: View {
    @ObservedObject var settings = SettingsServices()
    
    @State var timestampToggle: Bool = true
    @State var chatToggle: Bool = true
    @State var tlToggle: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $timestampToggle) {
                Text("time-toggle")
            }.onChange(of: timestampToggle, perform: { value in
                settings.timestamps = value
                settings.objectWillChange.send()
            }).onAppear {
                timestampToggle = settings.timestamps
            }
            Toggle(isOn: $chatToggle, label: {
                Text("chat-toggle")
            }).onChange(of: chatToggle, perform: { value in
                settings.showChat = value
                settings.objectWillChange.send()
            }).onAppear(){
                chatToggle = settings.showChat
            }
            Toggle(isOn: $tlToggle, label: {
                Text("tl-toggle")
            }).onChange(of: tlToggle, perform: { value in
                settings.showTls = value
                settings.objectWillChange.send()
            }).onAppear(){
                chatToggle = settings.showTls
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
