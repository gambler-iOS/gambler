//
//  MapTestView.swift
//  gambler
//
//  Created by cha_nyeong on 3/6/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct KakaoStaticView: View {
    let shop: Shop
    @State private var draw: Bool = false
    // 뷰의 appear 상태를 전달하기 위한 변수.
    var body: some View {
        KakaoMapDefaultView(shopLocate: shop.location, draw: $draw)
            .onAppear(perform: {
                self.draw = true
            })
            .onDisappear(perform: {
                self.draw = false
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
//
//#Preview {
//    KakaoStaticView(shop: <#Shop#>)
//}
