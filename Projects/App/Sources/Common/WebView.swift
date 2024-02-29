//
//  WebView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation
import SwiftUI
import SafariServices

struct WebView: UIViewControllerRepresentable {
    var siteURL: String
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeUIViewController(context: Context) -> UIViewController {
           if let url = URL(string: siteURL) {
               return SFSafariViewController(url: url)
           } else {
               return UrlErrorViewController()
           }
       }
}

class UrlErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "Url Error"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height)
        view.addSubview(label)
        view.backgroundColor = .white
    }
}

