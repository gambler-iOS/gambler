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
    @EnvironmentObject private var shopDetailViewModel: ShopDetailViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel // test용
   // @Binding var path: NavigationPath
    @State private var offsetY: CGFloat = CGFloat.zero
    let testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    let mainImageHeight: CGFloat = 200
    
    var type: DetailViewSegment
    var shop: Shop?
    var game: Game?
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                
                    /// 매장, 게임 이미지 넣는부분
                    /// type == shop ? shop.shopImage : game.gameImage
                    KFImage(URL(string: testImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    ///
                
                .frame(
                    width: geometry.size.width,
                    height: mainImageHeight + (offset > 0 ? offset : 0)
                )
                .offset(y: (offset > 0 ? -offset : 0))
                RoundSpecificCorners()
                    .offset(y: mainImageHeight - 20)
            }
            .frame(minHeight: mainImageHeight)
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                HStack{
                    Text((type == .shop ? shop?.shopName : game?.gameName) ?? "타이틀")
                        .font(.title2)
                        .bold()
                    Group{
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", (type == .shop ? shop?.reviewRatingAverage : game?.reviewRatingAverage) ?? 0.0))
                    }
                    .font(.subheadline)
                        .foregroundColor(.pink)
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.leading, 24)
                /// 스크롤뷰
                VStack {
                    HStack{
                        if type == .shop {
                            Text(shop?.shopAddress ?? "주소정보 없음")
                        }
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 24, bottom: 20, trailing: 0))
                    DetailViewButton(type: type)
                        .padding(.bottom, -15)
                    
                    switch type {
                    case .shop:
                        ShopDetailInnerView(shop: shop)
                    case .game:
                        GameDetailInnerView(game: game)
                    }
                }
                
            }.background(.white)
        }
        .overlay(
            Group{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(offsetY > -mainImageHeight ? 0 : 1)
            }
            , alignment: .top
        )
        .onAppear {
            Task {
                print("=== fetch shopDetailViewModel ==")
                // await shopDetailViewModel.fetchOneData(byId: shop.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Back to List") {
                    //path = NavigationPath()
                }
            }
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

    DetailView(type: .shop, shop: Shop(id: UUID().uuidString, shopName: "shop", shopAddress: "address",
                                             shopImage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
                                             shopPhoneNumber: "010-5555", menu: ["커피": 1000, "아이스티": 2000],
                                             openingHour: "10시", amenity: ["주차","담요","와이파이"], shopDetailImage: ["detailImage"],
                                             createdDate: Date(), reviewCount: 3,
                                             reviewRatingAverage: 3.5))
}
