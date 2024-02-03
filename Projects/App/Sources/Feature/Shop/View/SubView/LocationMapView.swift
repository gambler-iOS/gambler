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
                    .bold()
                Spacer()
            }
            KakaoMapView(draw: $draw, userLatitude: .constant(10), userLongitude: .constant(10), isShowingSheet: .constant(false))
                .onAppear {
                    Task {
                        self.draw = true
                    }
                }
                .allowsHitTesting(false)
                .frame(width: 350, height: 200)
                .cornerRadius(10)
                .padding()
                
        }.padding(20)
    }
}

#Preview {
    LocationMapView()
}
