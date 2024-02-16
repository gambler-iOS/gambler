//
//  TestView.swift
//  gambler
//
//  Created by daye on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MainMapView: View {
    @State private var dragOffset = CGFloat(UIScreen.main.bounds.size.height - 80)
    @State private var currentOffset = CGFloat(UIScreen.main.bounds.size.height - 80)
    @State private var isShowingMapButton: Bool = false
    var body: some View {
        ZStack {
            MapView()
            CustomSheetView()
                .offset(y: dragOffset > 0 ? dragOffset : 0)
                .gesture( DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.height + currentOffset
                    }
                    .onEnded { gesture in
                        dragOffset = gesture.translation.height + currentOffset
                        withAnimation(dragOffset > UIScreen.main.bounds.size.height*(1/4) ?
                            .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0): .easeInOut) {
                                
                                if dragOffset > UIScreen.main.bounds.size.height*(3/4) {
                                    dragOffset = UIScreen.main.bounds.size.height - 80
                                    isShowingMapButton = false
                                } else if dragOffset < UIScreen.main.bounds.size.height*(3/4) && dragOffset > UIScreen.main.bounds.size.height*(1/4) {
                                    dragOffset = UIScreen.main.bounds.size.height/2
                                    isShowingMapButton = false
                                } else {
                                    dragOffset = 0
                                    isShowingMapButton = true
                                }
                            }
                        currentOffset = dragOffset
                        print(currentOffset)
                    })
                .overlay {
                    if isShowingMapButton {
                        Button {
                            withAnimation {
                                isShowingMapButton.toggle()
                                dragOffset = UIScreen.main.bounds.size.height - 80
                                currentOffset = dragOffset
                            }
                        } label: {
                            Text("지도보기")
                                .frame(width: 97, height: 44)
                                .background(Color.gray)
                                .foregroundStyle(Color.white)
                                .cornerRadius(10)
                                .bold()
                        }.offset(y: UIScreen.main.bounds.size.height/2 - 80)
                    }
                }
        }
            
    }

}

#Preview {
    MainMapView()
}
