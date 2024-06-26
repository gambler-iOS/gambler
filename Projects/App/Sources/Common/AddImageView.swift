//
//  AddImageView.swift
//  gambler
//
//  Created by 박성훈 on 2/23/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import PhotosUI

struct AddImageView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var selectedPhotosData: [Data]
    @Binding var topPadding: CGFloat
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                if selectedPhotosData.count < 4 {
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                        VStack {
                            Image("Plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 64, height: 64)
                        .background(Color.gray100)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .onChange(of: selectedItems) { _, newItems in
                        for newItem in newItems {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    selectedPhotosData.append(data)
                                }
                            }
                        }
                    }
                }
                
                ForEach(selectedPhotosData.indices, id: \.self) { index in
                    if let image = UIImage(data: selectedPhotosData[index]) {
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(.rect(cornerRadius: 8))
                            
                            Button {
                                selectedPhotosData.remove(at: index)
                            } label: {
                                Image("searchClosedPrimary")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            .offset(x: 32, y: -32)
                        }
                    }
                }
                .onDelete { indexSet in
                    selectedPhotosData.remove(atOffsets: indexSet)
                }
            }
            .padding(.top, topPadding)
        }
    }
}

#Preview {
    AddImageView(selectedPhotosData: .constant([]), topPadding: .constant(16))
}
