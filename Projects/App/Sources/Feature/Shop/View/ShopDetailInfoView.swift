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
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var shopDetailViewModel: ShopDetailViewModel
    @EnvironmentObject private var tabSelection: TabSelection
    @State private var offsetY: CGFloat = CGFloat.zero
    @State private var isShowingFullScreen: Bool = false
    @State private var url: URL?
    @State private var isHeartButton: Bool = false
    @State private var isNavigation: Bool = false
    @State private var isShowingToast: Bool = false
    
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
                
                ItemButtonSetView(type: .shop, isShowingToast: $isShowingToast, shop: shop)
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
                
                ShopDetailHeaderView(shop: shop) {
                    guard loginViewModel.currentUser != nil else {
                        switch tabSelection.selectedTab {
                        case 0:
                            appNavigationPath.homeViewPath.append(true)
                        case 1:
                            appNavigationPath.mapViewPath.append(true)
                        case 2:
                            appNavigationPath.searchViewPath.append(true)
                        case 3:
                            appNavigationPath.myPageViewPath.append(true)
                        default:
                            appNavigationPath.isGoTologin = false
                        }
                        return
                    }
                    isNavigation = true
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                if shop.reviewCount != 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(shopDetailViewModel.reviews) { review in
                                ReviewListCellView(review: review)
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
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
                    .disabled(true)
            }
            .navigationDestination(isPresented: $isNavigation) {
                ReviewDetailView(reviewableItem: shop, targetName: shop.shopName)
            }
            .task {
                await shopDetailViewModel.fetchReviewData()
                await shopDetailViewModel.fetchShopInfo()
            }
            .background(.white)
            .navigationTitle(offsetY < -5 ? "\(shop.shopName)" : "")
            .navigationBarTitleDisplayMode(.inline)
            .modifier(BackButton())
            .buttonStyle(HiddenClickAnimationButtonStyle())
            .overlay(
                safetyAreaScreenView, alignment: .top
            )
            .overlay {
                if isShowingToast {
                    toastMessageView
                        .padding(.horizontal, 24)
                }
            }
            .onAppear {
                if let curUser = loginViewModel.currentUser, let likeShopArray = curUser.likeShopId {
                    isHeartButton = likeShopArray.contains { $0 == shop.id }
                }
            }

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
            .frame(width: UIScreen.main.bounds.width, height: 800)
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
    
    private var toastMessageView: some View {
        CustomToastView(content: "리뷰 작성이 완료되었습니다!")
            .offset(y: UIScreen.main.bounds.height * 0.3)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isShowingToast = false
                    }
                }
            }
    }
}

#Preview {
    ShopDetailInfoView(shop: Shop.dummyShop)
        .environmentObject(ShopListViewModel())
        .environmentObject(AppNavigationPath())
        .environmentObject(LoginViewModel())
}
