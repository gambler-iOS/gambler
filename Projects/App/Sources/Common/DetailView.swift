//
//  ShopDetailView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @State private var offsetY: CGFloat = CGFloat.zero
    let mainImageHeight: CGFloat = 200
    var type: AppConstants.MyPageFilter
    var shop: Shop?
    var game: Game?
    
    let testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                KFImage(URL(string: type == .shop ? shop?.shopImage ?? testImage :  game?.gameImage ?? testImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(
                        width: geometry.size.width,
                        height: mainImageHeight + (offset > 0 ? offset : 0)
                    )
                    .offset(y: (offset > 0 ? -offset : 0))
                RoundCornerView
                    .offset(y: mainImageHeight - 20)
            }
            .frame(minHeight: mainImageHeight)
            
            TitleView
                .padding(EdgeInsets(top: 10, leading: 24, bottom: 0, trailing: 0))
            AddressView
                .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 0))
            ItemButtonSetView(type: type)
                .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            
            /// 이 부분에 게임 이너뷰 추가하시면 됩니다!
            switch type {
            case .shop:
                ShopDetailInnerView(shop: shop!)
                    .padding(.bottom, 400)
            case .game:
                EmptyView()
                // GameDetailInnerView(game: game)
                // .padding(.bottom, 30)
            }
        }
        .background(.white)
        .overlay(
            safetyAreaScreenView, alignment: .top
        )
    }
    
    private var  RoundCornerView: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: 40)
            .roundedCorner(20, corners: [.topLeft, .topRight])
    }
    
    private var TitleView: some View {
        HStack {
            Text((type == .shop ? shop?.shopName : game?.gameName) ?? "none title")
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            ReviewRatingCellView(rating: shop?.reviewRatingAverage ?? 0.0)
            Spacer()
        }
    }
    
    private var AddressView: some View {
        HStack {
            if type == .shop {
                Text(shop?.shopAddress ?? "none address")
                    .font(.body2M)
                    .foregroundStyle(Color.gray400)
            }
            Spacer()
        }
    }
    
    private var safetyAreaScreenView: some View {
        Group {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: getSafeAreaTop())
                .edgesIgnoringSafeArea(.all)
                .opacity(offsetY > -(mainImageHeight) + (getSafeAreaTop()/2) ? 0 : 1)
        }
    }
  
    private func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
                self.offsetY = offset
        }
        return EmptyView()
    }
}

#Preview {
    DetailView(type: .shop, shop: Shop.dummyShop)
}
