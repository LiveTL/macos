//
//  StreamerListView.swift
//  macos
//
//  Created by Andrew Glaze on 2/16/21.
//

import RxCocoa
import RxSwift
import SwiftUI
import common

struct StreamerListView: View {
    let model = HomeModel(AppServices())
    let errorRelay = BehaviorRelay<Error?>(value: nil)
    let bag = DisposeBag()

    @State var streamers: YTStreamers? = nil
    // @State var width: CGFloat? = nil
    @State var vidId: String? = nil
    @State var showVideoView: Bool = false
    @State var rows: [GridItem] = Array(repeating: .init(.fixed(400)), count: 2)
    @State private var showAlert: Bool = false
    @State private var alertError: String? = nil
    @State var loadingString: String = "Getting Streams..."

    var body: some View {
        ZStack {
            GeometryReader { geom in
                ZStack {
                    if showVideoView {
                        LiveStreamView(id: self.vidId ?? "CXArovLJ60A").isHidden(!showVideoView)
                    }
                    List {
                        Section(header: Text("Live")
                            .font(.largeTitle)) {
                            if streamers != nil {
                                LazyVGrid(columns: rows) {
                                    ForEach(streamers!.live, id: \.id) {
                                        stream in
                                        GeometryReader { _ in
                                            VideoThumbnailView(thumbnailId: URL(string: "https://img.youtube.com/vi/\(stream.yt_video_key!)/mqdefault.jpg")!, channelIcon: stream.channel.photo, title: stream.title, channel: stream.channel.name)
                                        }.frame(height: 280.0).onTapGesture {
                                            self.vidId = stream.yt_video_key!
                                            self.showVideoView = true
                                        }
                                    }
                                }
                            }
                            if streamers == nil {
                                Text(loadingString)
                                    .font(.title).padding()
                            }
                        }
                        Section(header: Text("Upcoming")
                            .font(.largeTitle)) {
                            if streamers != nil {
                                LazyVGrid(columns: rows) {
                                    ForEach(streamers!.upcoming, id: \.id) {
                                        stream in
                                        GeometryReader { _ in
                                            VideoThumbnailView(thumbnailId: URL(string: "https://img.youtube.com/vi/\(stream.yt_video_key!)/mqdefault.jpg")!, channelIcon: stream.channel.photo, title: stream.title, channel: stream.channel.name)
                                        }.frame(height: 280.0).onTapGesture {
                                            self.vidId = stream.yt_video_key!
                                            self.showVideoView = true
                                        }
                                    }
                                }
                            }
                            if streamers == nil {
                                Text(loadingString)
                                    .font(.title).padding()
                            }
                        }
                        Section(header: Text("Ended")
                            .font(.largeTitle)) {
                            if streamers != nil {
                                LazyVGrid(columns: rows) {
                                    ForEach(streamers!.ended, id: \.id) {
                                        stream in
                                        GeometryReader { _ in
                                            VideoThumbnailView(thumbnailId: URL(string: "https://img.youtube.com/vi/\(stream.yt_video_key!)/mqdefault.jpg")!, channelIcon: stream.channel.photo, title: stream.title, channel: stream.channel.name)
                                        }.frame(height: 280.0).onTapGesture {
                                            self.vidId = stream.yt_video_key!
                                            self.showVideoView = true
                                        }
                                    }
                                }
                            }
                            if streamers == nil {
                                Text(loadingString)
                                    .font(.title).padding()
                            }
                        }.onAppear {
                            self.model.fetchStreams()
                        }
                    }.onAppear {
                        errorRelay.compactMap { $0 }.subscribe(onNext: handle(_:)).disposed(by: bag)
                        model.output.errorRelay.compactMap { $0 }.subscribe(onNext: handle(_:)).disposed(by: bag)
                    }
                    //.frame(minWidth: 820, alignment: .center)
                    .onReceive(model.streamersDriver.publisher) {
                        self.streamers = $0
                    }
                    .isHidden(showVideoView)
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("An Error Occurred"), message: Text(self.alertError!), dismissButton: .cancel())
                    })
                }.onChange(of: geom.size.width, perform: { value in
                    var rowsNumber = (value / 400)
                    rowsNumber.round(.down)
                    self.rows = Array(repeating: .init(.fixed(400)), count: Int(rowsNumber))
                })
            }
        }
    }

    func handle(_ error: Error) {
        self.alertError = error.localizedDescription
        self.loadingString = "An Error Occurred.  Get in contact if it's unique!"
        self.showAlert = true
    }
}

struct StreamerListView_Previews: PreviewProvider {
    static var previews: some View {
        StreamerListView()
    }
}
