//
//  AnnouncementsView.swift
//  gambler
//
//  Created by daye on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct AnnouncementsView: View {
    @StateObject private var announcementsViewModel = AnnouncementsViewModel()
    @State private var showingWebSheet: Bool = false
    @State private var urlLink: String = ""
    
    var body: some View {
        ScrollView {
            if announcementsViewModel.notices.isEmpty {
                Spacer()
                Text("공지사항이 없습니다.")
                    .onTapGesture {
                        showingWebSheet = true
                        //urlLink = notice.noticeLink
                    }
                Spacer()
            } else {
                ForEach(announcementsViewModel.notices) { notice in
                    announcementsCellView(title: notice.noticeTitle,
                                          createdDate: notice.createdDate)
                    .padding(8)
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        showingWebSheet = true
                        urlLink = notice.noticeLink
                    }
                    Divider()
                }
            }
        }
        .fullScreenCover(isPresented: $showingWebSheet) {
            WebView(siteURL: "https://raw.githubusercontent.com/gambler-iOS/gambler-WebPage/main/Terms%20of%20Use.md")
        }
        .navigationTitle("공지사항")
        .modifier(BackButton())
        .onAppear {
            Task {
                await announcementsViewModel.fetchData()
            }
        }
    }
    
    private func announcementsCellView(title: String, createdDate: Date) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body1M)
                .foregroundStyle(Color.gray900)
                .padding(.bottom, 8)
            Text("\(GamblerDateFormatter.shared.calendarDateString(from: createdDate))")
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
