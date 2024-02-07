//
//  DetailViewButton.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct DetailViewButton: View {
    var type: DetailViewSegment
    
    var body: some View {
        HStack{
            switch type {
            case .shop:
                Group{
                    makeButton(image: "phone", buttonName: "전화")
                    makeButton(image: "heart.fill", buttonName: "찜하기")
                    makeButton(image: "square.and.pencil", buttonName: "리뷰")
                }
                
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
            }.padding(30)
    }
}

#Preview {
    DetailViewButton(type: .game)
}
