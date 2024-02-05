//
//  MyPageViewModel.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import Foundation

final class MyPageViewModel: ObservableObject {
 
    enum LikeCategory: String, CaseIterable { 
        case shop = "매장"
        case game = "게임"
    }
    
    @Published var user: User
    
    init() {
        user = User(nickname: "성훈이", profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png")
    }
    
    func generateDummyData() {
        
    }
    
    
}
