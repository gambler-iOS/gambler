//
//  ShopDetailView.swift
//  gambler
//
//  Created by daye on 1/25/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

// struct ShopDetailView: View {
//     @EnvironmentObject private var shopDetailViewModel: ShopDetailViewModel
//     @EnvironmentObject private var homeViewModel: HomeViewModel // test용
//     @Binding var path: NavigationPath
//     let shop: Shop

//     var body: some View {
//         ScrollView {
//             if let shop = shopDetailViewModel.shop {
//                 Text(shop.id)
//                 Text(shop.shopName)
//                 HomeShopListView(path: $path, title: "추천 매장", shops: homeViewModel.popularShops)
//                 // TODO: 프로토콜 형식으로 넘길 때 binding 걸 수 있을까? reviewView 에서 이전 shop 데이터 가지고 있는 문제 있음
//                 // ReviewView(postData: shop)
//             } else {
//                 Text("매장 정보 없음")
//             }
//         }
//         .onAppear {
//             Task {
//                 print("=== fetch shopDetailViewModel ==")
//                 await shopDetailViewModel.fetchOneData(byId: shop.id)
//             }
//         }
//         .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//               Button("Back to List") {
//                  path = NavigationPath()
//               }
//            }

import Kingfisher

struct ShopDetailView: View {
    private var testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    private var shopImageHeight: CGFloat = 200
    @State private var offsetY: CGFloat = CGFloat.zero
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                ZStack {
                    /// 매장, 게임 이미지 넣는부분
                    AsyncImage(url: URL(string: testImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    ///
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
                    /// 스크롤뷰
                    VStack {
                        HStack{
                            Text("주손ㅇㅇ냥냐ㅓㅇ넝ㄴ앙ㄴㅇㄴㅇㄴㅇㄴ")
                            Spacer()
                        }.padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 0))
                        DetailViewButton()
                            .padding(.bottom, -15)
                        ShopDetailInnerView()
                    }
                    ///
                }
            }.background(.white)
        }
        .overlay(
            Group{
                Rectangle()
                 .foregroundColor(.white)
                 .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                 .edgesIgnoringSafeArea(.all)
                 .opacity(offsetY > -shopImageHeight ? 0 : 1)
            }
            , alignment: .top
        )
        //.... 지울까?
    }
    
    private func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.offsetY = offset
        }
        return EmptyView()
    }
    
    private struct HeaderView: View {
        fileprivate var body: some View {
            HStack{
                Text("레드버튼 선릉점")
                    .font(.title2)
                    .bold()
                Group{
                    Image(systemName: "star.fill")
                    Text("4.5")
                }.font(.subheadline)
                .foregroundColor(.pink)
                .padding(.leading, 10)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 30)
            .background(.white)
        }
    }
    
   
}

#Preview {
//     ShopDetailView(path: .constant(NavigationPath()),
//                    shop: Shop(id: UUID().uuidString, shopName: "shop", shopAddress: "address",
//                               shopImage: "image", location: GeoPoint(latitude: 120.1, longitude: 140),
//                               shopPhoneNumber: "010-5555", menu: ["커피": 1000],
//                               openingHour: "10시", amenity: ["주차"], shopDetailImage: ["detailImage"],
//                               createdDate: Date(), reviewCount: 3,
//                               reviewRatingAverage: 3.5))
    ShopDetailView()
}
