//
//  HeartCellView.swift
//  gambler
//
//  Created by Hyo Myeong Ahn on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct HeartCellView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let postId: String
    let postType: AppConstants.PostType
    @State private var isLiked: Bool = false
    
    private var getCurrentHeartState: Bool {
        if let curUser = loginViewModel.currentUser {
            if postType == .game {
                if let likeGameArray = curUser.likeGameId {
                    return likeGameArray.contains { $0 == postId }
                }
            } else if postType == .shop {
                if let likeShopArray = curUser.likeShopId {
                    return likeShopArray.contains { $0 == postId }
                }
            }
        }
        return false
    }
    
    var body: some View {
        VStack {
            if isLiked {
                GamblerAsset.heartRed.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.primaryDefault)
            } else {
                GamblerAsset.heartGray.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.gray300)
            }
        }
        .onAppear {
            isLiked = getCurrentHeartState
        }
        .onTapGesture {
            isLiked.toggle()
            updateLikeList()
        }
    }
    
    private func updateLikeList() {
        guard var curUser = loginViewModel.currentUser else {
            appNavigationPath.isGoTologin = true
            return
        }
        var userLikeDictionary: [AnyHashable: Any] = [:]
        var userLikeCountDictionary: [AnyHashable: Any] = [:]
        var likeKey: String = ""
        var updatedLikeArray: [String] = []
        var countLike: Int = curUser.myLikesCount

        if postType == .game {
            likeKey = "likeGameId"
            if let likeGameIdArray = curUser.likeGameId {
                updatedLikeArray = likeGameIdArray
            }
        } else {
            likeKey = "likeShopId"
            if let likeShopIdArray = curUser.likeShopId {
                updatedLikeArray = likeShopIdArray
            }
        }
        
        if isLiked {
            countLike += 1
            updatedLikeArray.append(postId)
        } else {
            countLike -= 1
            updatedLikeArray.removeAll { $0 == postId }
        }
        
        if postType == .game {
            loginViewModel.currentUser?.likeGameId = updatedLikeArray
        } else {
            loginViewModel.currentUser?.likeShopId = updatedLikeArray
        }
        
        userLikeDictionary[likeKey] = updatedLikeArray
        userLikeCountDictionary["myLikesCount"] = countLike
        Task {
            await loginViewModel.updateLikeList(likePostIds: userLikeDictionary, likeCount: userLikeCountDictionary)
            
            await myPageViewModel.fetchLikeGames(user: loginViewModel.currentUser)
            await myPageViewModel.fetchLikeShops(user: loginViewModel.currentUser)
        }
    }
}

#Preview {
    HeartCellView(postId: "", postType: AppConstants.PostType.game)
}
