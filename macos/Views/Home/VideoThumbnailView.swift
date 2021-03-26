//
//  VideoThumbnailView.swift
//  macos
//
//  Created by Andrew Glaze on 2/17/21.
//
// import Kingfisher
import struct Kingfisher.KFImage
import SwiftUI
import common

struct VideoThumbnailView: View {
    @State var thumbnailId: URL
    @State var channelIcon: URL
    @State var title: String
    @State var channel: String

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    ZStack {
                        VStack(alignment: .trailing) {
                            HStack(alignment: .top) {
                                Spacer()
                                    .frame(width: 23.0, height: 1.0)
                                KFImage(thumbnailId)
                                    .overlay(
                                        HStack {
                                            VStack {
                                                Spacer()
                                                    .frame(width: 12.0, height: 200.0)
                                                KFImage(channelIcon)
                                                    .resizable()
                                                    .frame(width: 100.0, height: 100.0)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                                            }
                                            Spacer()
                                                .frame(width: 300.0, height: 12.0)
                                        }
                                    )
                                Spacer()
                                    .frame(width: 13.0)
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 88.0, height: 11.0)
                                VStack(alignment: .leading) {
                                    Text(title).font(.title).lineLimit(2).fixedSize(horizontal: false, vertical: true)
                                    Text(channel).fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }
            }.padding()

        }.frame(width: 382.0, height: 280.0).padding()
    }
}

struct VideoThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoThumbnailView(thumbnailId: URL(string: "https://img.youtube.com/vi/d6ouim9ZsyI/mqdefault.jpg")!, channelIcon: URL(string: "https://yt3.ggpht.com/ytc/AAUvwniCgko15I_x5bYWm0G2vnf5hZqD5hLOtLEDw0Na=s176-c-k-c0x00ffffff-no-rj")!, title: "【#生スバル​】おはようスバル：FREE TALK【ホロライブ/大空スバル】", channel: "Subaru Ch. 大空スバル")
    }
}
