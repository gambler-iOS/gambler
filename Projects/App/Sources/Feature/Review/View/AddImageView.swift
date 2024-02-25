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
    @State private var selectedPhotosData: [Data] = []
    
    var body: some View {
        HStack(spacing: 8) {
            // maxSelection이라는 매개변수에 값을 5로 설정하면 사용자가 최대 5장의 사진을 지원할 수 있다.
            if selectedPhotosData.count < 4  {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.gray400)
                    }
                    .frame(width: 64, height: 64)
                    .background(Color.gray100)
                    .clipShape(.rect(cornerRadius: 8))
                }
                // onChange 클로저에서 두 개 이상의 사진을 캡처할 수 있다.
                // 각 사진 항목을 로드하여 데이터 배열에 추가함
                .onChange(of: selectedItems) { newItems in
                    for newItem in newItems {
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                selectedPhotosData.append(data)
                            }
                        }
                    }
                }
            }
            
            ForEach(selectedPhotosData, id: \.self) { photoData in
                if let image = UIImage(data: photoData) {
                    
                    ZStack(alignment: .topTrailing) {
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(.rect(cornerRadius: 8))
                        
                        Button {
                            // removeAll로 하니까 다 지워짐
                            selectedPhotosData.removeAll { $0 == photoData }
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.red)
                                .padding(4)
                        }
                        .offset(x: 4, y: -4)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AddImageView()
}
