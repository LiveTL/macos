//
//  LiveStreamView.swift
//  macos
//
//  Created by Andrew Glaze on 2/5/21.
//

import AVKit
import RxCocoa
import RxSwift
import SwiftUI
import XCDYouTubeKit
import common

let astring: NSAttributedString = {
    let path = Bundle.main.url(forResource: "text-with-image", withExtension: "rtfd")!.path
    return (try! NSAttributedString(url: URL(fileURLWithPath: path), options: [:], documentAttributes: nil))
}()

struct LiveStreamView: View {
    // UI Stuff
    @State private var video: XCDYouTubeVideo? = nil // Video Object
    @State var id: String // YT Video ID
    @State private var vidHide: Bool = true // Determines if the video View is hidden or not
    @State private var player: AVPlayer? = nil // the Video Player Object
    @State private var loadMessage: String = "Hang tight just one second, m'kay?   " // The message on the load screen
    @State private var chatUrl = URL(string: "https://www.google.com")!
    @State private var showAlert: Bool = false
    @State private var alertError: String? = nil

    // Program Stuff
    var model = WatchModel(AppServices())
    let errorRelay = BehaviorRelay<Error?>(value: nil)
    let bag = DisposeBag()
    let chatEventObservable = BehaviorRelay<(Double, String)?>(value: nil)

    var body: some View {
        HSplitView {
            ZStack {
                VStack(spacing: 0) {
                    // SwiftUI Bug - VideoPlayer() causes a crash unless an AttributedString() with an image is loaded.  Something to do with failing to de-mangle stuff.
                    AttributedText(astring)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                        .onAppear(perform: {
                            XCDYouTubeClient.default().getVideoWithIdentifier(id) { Ytvideo, error in
                                guard error == nil else { print(error!)
                                    self.errorRelay.accept(error)
                                    return
                                }
                                if let Ytvideo = Ytvideo {
                                    video = Ytvideo
                                    vidHide = false
                                }
                            }
                        })

                    // Invisible WebView that loads YTC
                    WebView(request: URLRequest(url: chatUrl), model: model, chatEventObservable: chatEventObservable)
                        .onReceive(self.model.chatURLDriver.publisher, perform: {
                            self.chatUrl = $0
                        })
                        .hidden()
                        .frame(width: 0, height: 0)
                    if !vidHide {
                        VideoPlayer(player: player)
                            .onAppear {
                                player = AVPlayer(url: (video?.streamURL! ?? URL(string: "https://billwurtz.com/shaving-my-piano.mp4"))!)
                                player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.pause
                                player?.automaticallyWaitsToMinimizeStalling = true
                                player?.play()
                                let time = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                                player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { playTime in
                                    self.chatEventObservable.accept((playTime.seconds, video!.identifier))
                                }
                                model.performChatLoad(video!.identifier, duration: video!.duration)
                            }
                            .onDisappear {
                                player?.pause()
                            }
                    }
                }
                HStack {
                    // Loading Screen
                    Text(loadMessage)
                        .font(.largeTitle).isHidden(!vidHide)
                    ProgressView().progressViewStyle(CircularProgressViewStyle()).isHidden(!vidHide)
                }.padding()
            }

            VSplitView {
                // Chat(s)
                ScrollingChatView(model: model)
                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, idealHeight: 360, maxHeight: .infinity, alignment: .center)
                ScrollingTlView(model: model)
                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, idealHeight: 360, maxHeight: .infinity, alignment: .center)
            }.alert(isPresented: self.$showAlert, content: {
                Alert(title: Text("An Error Occurred"), message: Text(self.alertError!), dismissButton: .cancel())
            })
        }.onAppear {
            errorRelay.compactMap { $0 }.subscribe(onNext: handle(error:)).disposed(by: bag)
        }
    }

    func handle(error: Error) {
        self.alertError = error.localizedDescription
        self.loadMessage = "An Error Occurred.  Get in contact if it's unique!   "
        self.showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LiveStreamView(id: "CXArovLJ60A")
    }
}
