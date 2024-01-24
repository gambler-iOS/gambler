//
//  WebView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 1/24/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
   let urlToLoad: String

   func makeUIView(context: Context) -> WKWebView {
      let view = WKWebView()
      let request = URLRequest(url: URL(string: urlToLoad) ??
                               URL(string: "https://www.naver.com")!)
      view.load(request)
      return view
   }
   func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    WebView(urlToLoad: "https://www.apple.com")
}
