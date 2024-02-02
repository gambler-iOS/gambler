//
//  ShopDetailView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ShopDetailView: View {
    
    var testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    var shopImageHeight: CGFloat = 200
    
    @State private var offsetY: CGFloat = CGFloat.zero
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                ZStack {
                    AsyncImage(url: URL(string: testImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(
                  width: geometry.size.width,
                  height: shopImageHeight + (offset > 0 ? offset : 0)
                )
                .offset(y: (offset > 0 ? -offset : 0))
                RoundSpecificCorners()
                    .offset(y: shopImageHeight - 20)
            }
            .frame(minHeight: shopImageHeight)
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: HeaderView()) {
                    VStack {
                        ForEach(0...30, id: \.self) { index in
                            Text("\(index)item")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }.background(.white)
        }
        .overlay( //네비게이션바
            Rectangle()
                .foregroundColor(.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.all)
                .opacity(offsetY > -shopImageHeight ? 0 : 1)
            , alignment: .top
        )

        
    }
    
    func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.offsetY = offset
        }
        return EmptyView()
    }
    
    private struct HeaderView: View {
        fileprivate var body: some View {
            HStack {
                Spacer()
                Text("레드버튼 선릉점")
                    .font(.title)
                    .bold()
                    .foregroundColor(.blue)
                Spacer()
            }
            .background(.white)
        }
    }
}

#Preview {
    ShopDetailView()
}
