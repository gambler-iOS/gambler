//
//  AnnouncementsView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct AnnouncementsView: View {
    @State var showingWebSheet: Bool = false
    
    var body: some View {
        List(0..<5, id: \.self) { _ in
            VStack(alignment: .leading, spacing: .zero) {
                Text(Notice.dummyNotice.noticeTitle)
                    .font(.body1M)
                    .padding(.vertical, 8)
                    .foregroundStyle(Color.gray900)
                Text("\(Notice.dummyNotice.createdDate)")
                    .font(.body2M)
                    .padding(.vertical, 8)
                    .foregroundStyle(Color.gray400)
            }
            .frame(height: 85)
            .onTapGesture {
                showingWebSheet = true
            }
        }
        .sheet(isPresented: $showingWebSheet) {
            WebView(siteURL: "")
        }
        .listStyle(.plain)
        .navigationTitle("공지사항")
        .modifier(BackButton())
    }
}

#Preview {
    AnnouncementsView()
}
