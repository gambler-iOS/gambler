//
//  DetailViewButton.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import UIKit

struct DetailViewButton: View {
    var type: DetailViewSegment
    let phoneNumber = "tel://123456789"
    
    var body: some View {
        HStack{
            switch type {
            case .shop:
                Group{
                    Button {
                        makePhoneCall()
                    } label: {
                        makeButton(image: "phone", buttonName: "전화")
                    }
                    makeButton(image: "heart.fill", buttonName: "찜하기")
                    makeButton(image: "square.and.pencil", buttonName: "리뷰")
                }.foregroundStyle(.black)
                
            case .game:
                Group{
                    makeButton(image: "heart.fill", buttonName: "찜하기")
                    makeButton(image: "square.and.pencil", buttonName: "리뷰")
                }.padding(.horizontal, 20)
            }
        }
    }
    
    
    private func makeButton(image: String, buttonName: String) -> some View {
        return
            HStack{
                Image(systemName: image)
                Text(buttonName)
            }.padding(20)
    }
    
    func makePhoneCall() {
        if let phoneURL = URL(string: phoneNumber), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    DetailViewButton(type: .shop)
}
