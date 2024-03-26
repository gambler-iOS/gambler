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
    @EnvironmentObject private var appNavigationPath: AppNavigationPath
    let isLike: Bool
    let postId: String
    let postType: AppConstants.PostType
    @State private var isLiked: Bool = false
//    var onHeartTapped: () -> Void = {}
    
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
            isLiked = isLike
        }
        .onTapGesture {
            isLiked.toggle()
            updateLikeList()
        }
    }
    
    private func updateLikeList() {
        guard var curUser = loginViewModel.currentUser else {
            appNavigationPath.homeViewPath.append("로그인")
            return
        }
        
        var userLikeDictionary: [AnyHashable: Any] = [:]
        var likeKey: String = ""
        var updatedLikeArray: [String] = []
        
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
            updatedLikeArray.append(postId)
        } else {
            updatedLikeArray.removeAll { $0 == postId }
        }
        
        if postType == .game {
            curUser.likeGameId = updatedLikeArray
        } else {
            curUser.likeShopId = updatedLikeArray
        }
        
        userLikeDictionary[likeKey] = updatedLikeArray
        
        Task {
            await loginViewModel.updateLikeList(likePostIds: userLikeDictionary)
        }
    }
}

#Preview {
    HeartCellView(isLike: true, postId: "", postType: AppConstants.PostType.game)
}
