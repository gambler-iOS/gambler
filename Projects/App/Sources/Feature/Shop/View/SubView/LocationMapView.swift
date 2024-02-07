//
//  LocationMapView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct LocationMapView: View {
    @State var draw: Bool = false
    var body: some View {
        VStack{
            HStack{
                Text("위치")
                    .font(.title3)
                    .bold()
                Spacer()
            }.padding(.bottom, 24)
            KakaoMapView(draw: $draw, userLatitude: .constant(10), userLongitude: .constant(10), isShowingSheet: .constant(false), isMainMap: false)
                .onAppear {
                    Task {
                        self.draw = true
                    }
                }
                .allowsHitTesting(false)
                .frame(width: 327, height: 215)
                .cornerRadius(8)
        }.padding(.horizontal, 24)
            .padding(.vertical, 32)
    }
}

#Preview {
    LocationMapView()
}
