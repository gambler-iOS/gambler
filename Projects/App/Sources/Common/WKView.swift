//
//  WKWebView.swift
//  gambler
//
//  Created by 박성훈 on 3/30/24.
//  Copyright © 2024 gamblerTeam. All rights reserved.
//

import SwiftUI
import WebKit

// SFSafariViewController는 위에 done 버튼이 있어 WKWebView 새로 만듦
struct WKView: UIViewRepresentable {
    @Binding var siteURL: String
    
    func makeUIView(context: Context) -> WKWebView {
        let wkwebView = WKWebView()
        
        guard let url = URL(string: siteURL) else {
            return wkwebView
        }
        
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
