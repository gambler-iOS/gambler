//
//  ItemButtonSet.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import UIKit

struct ItemButtonSetView: View {
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var tabSelection: TabSelection
    let type: MyPageFilter
    @Binding var isShowingToast: Bool
    var shop: Shop?
    var game: Game?
    
    @State private var heartState: Bool = false
    @State private var isWriteReviewButton: Bool = false
    
    private var getCurrentHeartState: Bool {
        if let curUser = loginViewModel.currentUser {
            if type == .game {
                if let likeGameArray = curUser.likeGameId {
                    return likeGameArray.contains { $0 == game?.id }
                }
            } else if type == .shop {
                if let likeShopArray = curUser.likeShopId {
                    return likeShopArray.contains { $0 == shop?.id }
                }
            }
        }
        return false
    }
    
    var body: some View {
        HStack(spacing: 0) {
            switch type {
            case .shop:
                ShopButtonSet
            case .game:
                GameButtonSet
            }
        }
        .onAppear {
            heartState = getCurrentHeartState
        }
    }
    
    private var ShopButtonSet: some View {
        return Group {
            ItemButtonView(image: GamblerAsset.phone.swiftUIImage, buttonName: "전화") {
                tappedCall()
            }
            ItemButtonView(image: heartState ? GamblerAsset.heartRed.swiftUIImage :
                        GamblerAsset.heartGray.swiftUIImage, buttonName: "찜하기") {
                updateLikeList()
            }
            ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                tappedReview()
            }
        }
        .navigationDestination(isPresented: $isWriteReviewButton) {
            if let shop {
                WriteReviewView(isShowingToast: $isShowingToast, reviewableItem: shop)
            }
        }
    }
    
    private var GameButtonSet: some View {
        Group {
            ItemButtonView(image: heartState ? GamblerAsset.heartRed.swiftUIImage :
                            GamblerAsset.heartGray.swiftUIImage, buttonName: "찜하기") {
                updateLikeList()
            }
            ItemButtonView(image: GamblerAsset.review.swiftUIImage, buttonName: "리뷰") {
                tappedReview()
            }
        }
        .navigationDestination(isPresented: $isWriteReviewButton) {
            if let game {
                WriteReviewView(isShowingToast: $isShowingToast, reviewableItem: game)
            }
        }
    }
    
    private func tappedCall() {
        if let phoneURL = URL(string: "tel://\(shop?.shopPhoneNumber ?? "번호 정보 없음"))"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    private func tappedReview() {
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
        isWriteReviewButton = true
    }
    
    private func updateLikeList() {
        guard let curUser = loginViewModel.currentUser else {
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
        var userLikeDictionary: [AnyHashable: Any] = [:]
        var likeKey: String = ""
        var updatedLikeArray: [String] = []
        var postId: String = ""
        
        if type == .game {
            likeKey = "likeGameId"
            postId = game?.id ?? ""
            if let likeGameIdArray = curUser.likeGameId {
                updatedLikeArray = likeGameIdArray
            }
        } else {
            likeKey = "likeShopId"
            postId = shop?.id ?? ""
            if let likeShopIdArray = curUser.likeShopId {
                updatedLikeArray = likeShopIdArray
            }
        }
        if postId.isEmpty {
            return
        }
        
        if heartState {
            updatedLikeArray.removeAll { $0 == postId }
            heartState = false
        } else {
            updatedLikeArray.append(postId)
            heartState = true
        }
        
        if type == .game {
            loginViewModel.currentUser?.likeGameId = updatedLikeArray
        } else {
            loginViewModel.currentUser?.likeShopId = updatedLikeArray
        }
        
        userLikeDictionary[likeKey] = updatedLikeArray
        
        Task {
            await loginViewModel.updateLikeList(likePostIds: userLikeDictionary)
        }
    }
}

struct ItemButtonView: View {
    let image: Image
    let buttonName: String
    let action: () -> Void
    
    var body: some View {
        return Button {
            action()
        } label: {
            HStack {
                image
                    .resizable()
                    .frame(width: 23.1, height: 23.1)
                Text(buttonName)
                    .foregroundStyle(Color.gray500)
                    .font(.body1M)
            }
            .frame(height: 72)
            .frame(maxWidth: .infinity)
        }
        
    }
}

#Preview {
//    ItemButtonSetView(type: .shop, shop: Shop.dummyShop)
    ItemButtonSetView(type: .game, isShowingToast: .constant(false), game: Game.dummyGame)
        .environmentObject(AppNavigationPath())
        .environmentObject(LoginViewModel())
}
