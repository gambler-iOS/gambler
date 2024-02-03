//
//  ShopDetailInfo.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ShopDetailInfo: View {
    var shop: Shop?
    var body: some View {
        VStack(alignment: .leading){
            Text("운영 시간")
            Text("편의")
            Text("이용 가격")
            Text("메뉴")
        }.padding()
        .bold()
    }
}

#Preview {
    ShopDetailInfo()
}
