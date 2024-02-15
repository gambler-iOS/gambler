//
//  GameDetailInnerView.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct GameDetailInnerView: View {
    var game: Game?
    
    var body: some View {
        VStack(alignment: .leading){
            Border()
            ReviewListCellView()
            Border()
        }.padding(.bottom, 30)
    }
}

#Preview {
    GameDetailInnerView()
}
