//
//  AnnouncementsView.swift
//  gambler
//
//  Created by daye on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct AnnouncementsView: View {
    @State var showingWebSheet: Bool = false
    @State var urlLink: String = ""
    
    var body: some View {
        ScrollView {
            ForEach(0..<5, id: \.self) { _ in
                announcementsCellView(title: Notice.dummyNotice.noticeTitle,
                                      createdDate: Notice.dummyNotice.createdDate)
                .padding(8)
                .padding(.horizontal, 8)
                .onTapGesture {
                    showingWebSheet = true
                    urlLink = Notice.dummyNotice.noticeLink
                }
                Divider()
            }
        }
        .sheet(isPresented: $showingWebSheet) {
            // WebView(siteURL: urlLink)
        }
        .navigationTitle("공지사항")
        .modifier(BackButton())
    }
    
    private func announcementsCellView(title: String, createdDate: Date) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body1M)
                .foregroundStyle(Color.gray900)
                .padding(.bottom, 8)
            Text("\(GamblerDateFormatter.shared.periodDateString(from: createdDate))")
                .font(.body2M)
                .foregroundStyle(Color.gray400)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
    
}

#Preview {
    AnnouncementsView()
}
