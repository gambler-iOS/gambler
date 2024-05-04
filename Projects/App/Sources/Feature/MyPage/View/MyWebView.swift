//
//  TermsOfUseView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MyWebView: View {
    @Binding var siteURL: String
    let title: String
    
    var body: some View {
        WKView(siteURL: $siteURL)
            .modifier(BackButton())
            .navigationTitle(title)
    }
}

#Preview {
    MyWebView(siteURL: .constant("https://www.naver.com"), title: "이용약관")
}
