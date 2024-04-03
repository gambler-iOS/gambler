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
    
    var body: some View {
        VStack {
            if announcementsViewModel.notices.isEmpty {
                Text("공지사항이 없습니다.")
                    .font(.body2B)
                    .foregroundStyle(Color.gray400)
            } else {
                ScrollView {
                    ForEach(announcementsViewModel.notices) { notice in
                        
                        NavigationLink(destination: 
                                        WKView(siteURL: .constant(notice.noticeLink))
                                            .navigationTitle(notice.noticeTitle)
                                            .modifier(BackButton())) {
                            announcementsCellView(title: notice.noticeTitle,
                                                  createdDate: notice.createdDate)
                            .padding(8)
                            .padding(.horizontal, 8)
                        }
                        Divider()
                    }
                }
            }
        }
        .navigationTitle("공지사항")
        .modifier(BackButton())
        .task {
            await announcementsViewModel.fetchData()
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
