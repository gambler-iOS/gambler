//
//  ShopDetailInfoView.swift
//  gambler
//
//  Created by cha_nyeong on 2/28/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct ShopDetailInfoView: View {
    
    @State private var offsetY: CGFloat = CGFloat.zero
    @State private var isShowingFullScreen: Bool = false
    @State private var url: URL?
    let mainImageHeight: CGFloat = 200
    let shop: Shop
    
    var body: some View {
        ZStack {
            ScrollView {
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    setOffset(offset: offset)
                    KFImage(URL(string: shop.shopImage))
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
                    .padding(.horizontal, 24)
                
                AddressView
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                
                ItemButtonSetView(type: .shop)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                
                BorderView()
                /// 이 부분에 게임 이너뷰 추가하시면 됩니다!
                ShopCostDetailView(shop: shop)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                
                if !(shop.shopDetailImage?.isEmpty ?? true) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("매장 추가 사진")
                            .font(.body1B)
                        ShopDetailImageListView(shop: shop, isShowingFullScreen: $isShowingFullScreen, url: $url)
                            .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
                
                BorderView()
                    .padding(.top, 32)
                
                ShopDetailHeaderView(shop: shop)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                
                if shop.reviewCount != 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<shop.reviewCount) { _ in
                                ReviewListCellView(review: .dummyShopReview)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                } else {
                    VStack {
                        Text("첫 번째 리뷰를 남겨주세요!")
                            .font(.body2M)
                            .foregroundStyle(Color.gray400)
                    }
                    .frame(height: 114)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                }
                
                BorderView()
                    .padding(.top, 32)
                
                mapHeaderView
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                
                KakaoStaticView(shop: shop)
                    .frame(height: 215)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .disabled(true)
            }
            .background(.white)
            .overlay(
                safetyAreaScreenView, alignment: .top
            )

            if isShowingFullScreen {
                withAnimation(.smooth()) {
                    FullScreenImageView(isShowingFullScreen: $isShowingFullScreen, url: $url)
                }
            }
        }
        
    }
    
    private var RoundCornerView: some View {
        Rectangle()
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width, height: 180)
            .roundedCorner(20, corners: [.topLeft, .topRight])
    }
    
    private var TitleView: some View {
        HStack {
            Text(shop.shopName)
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            ReviewRatingCellView(rating: shop.reviewRatingAverage)
            Spacer()
        }
    }
    
    private var AddressView: some View {
        HStack {
            Text(shop.shopAddress)
                .font(.body2M)
                .foregroundStyle(Color.gray400)
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
    
    private var mapHeaderView: some View {
        HStack(spacing: .zero) {
            Text("위치")
                .font(.subHead1B)
                .foregroundStyle(Color.gray700)
            Spacer()
        }
    }
}

#Preview {
    ShopDetailInfoView(shop: Shop.dummyShop)
        .environmentObject(ShopListViewModel())
}
