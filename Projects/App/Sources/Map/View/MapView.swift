//
//  TestView.swift
//  gambler
//
//  Created by daye on 2/16/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct MapView: View {
    @State private var dragOffset: CGFloat =  0
    @State private var currentOffset: CGFloat = 0
    @State private var isShowingMapButton: Bool = false
    
    var body: some View {
        ZStack {
            // 맵뷰 추가 위치
            CustomSheetView()
                .frame(height: UIScreen.main.bounds.size.height)
                .offset(y: dragOffset > 0 ? dragOffset : AppConstants.SheetHeight.full)
                .gesture( DragGesture()
                    .onChanged { gesture in
                        if !isShowingMapButton {
                            dragOffset = gesture.translation.height + currentOffset
                        }
                    }
                    .onEnded { gesture in
                        if !isShowingMapButton {
                            dragOffset = gesture.translation.height + currentOffset
                            decideSheetHeight()
                        }
                    })
                .overlay {
                    if isShowingMapButton {
                        ShowMapButton
                            .offset(y: AppConstants.SheetBoundary.button)
                    }
                }
        }.overlay(
            SafetyAreaTopScreen, alignment: .top
        )
        .background(Color.gray100)
        .onAppear {
            dragOffset = AppConstants.SheetHeight.bottom
            currentOffset = AppConstants.SheetHeight.bottom
            isShowingMapButton = false
        }
    }
    
    private var ShowMapButton: some View {
        GamblerAsset.showMap.swiftUIImage
            .resizable()
            .frame(width: 97, height: 44)
            .onTapGesture {
                withAnimation {
                    isShowingMapButton.toggle()
                    dragOffset = AppConstants.SheetHeight.bottom
                    currentOffset = dragOffset
                }
            }
    }
    
    private var SafetyAreaTopScreen: some View {
        Group {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: getSafeAreaTop() + 20)
                .edgesIgnoringSafeArea(.all)
                .opacity(dragOffset < getSafeAreaTop() + 20 ? 1 : 0)
        }
    }
    
    private func decideSheetHeight() {
        withAnimation(dragOffset > AppConstants.SheetBoundary.high  ?
            .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0): .easeInOut) {
                
                if dragOffset > AppConstants.SheetBoundary.low {
                    dragOffset = AppConstants.SheetHeight.bottom
                    isShowingMapButton = false
                    
                } else if dragOffset < AppConstants.SheetBoundary.low
                            && dragOffset > AppConstants.SheetBoundary.high {
                    dragOffset = AppConstants.SheetHeight.middle
                    isShowingMapButton = false
                    
                } else {
                    dragOffset = AppConstants.SheetHeight.full
                    isShowingMapButton = true
                }
            }
        currentOffset = dragOffset
    }
}

#Preview {
    MapView()
}
