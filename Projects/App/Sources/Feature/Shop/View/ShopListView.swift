//
//  ShopListView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopListView: View {
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        VStack{
            NavigationLink {
                ShopDetailView()
            } label: {
                Text("다음")
            }
            
            Button {
                isShowingSheet = false
            } label: {
                Text("모달 닫기")
            }

        }
    }
}
