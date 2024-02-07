//
//  SectionHeader.swift
//  gambler
//
//  Created by daye on 2/7/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    var rating: String?
    var body: some View {
        HStack{
            Text(title)
                .font(.title3)
            if let content = rating {
                Text(content)
                .foregroundStyle(.pink)
                .font(.headline)
            }
            Spacer()
            Image(systemName: "greaterthan")
                .foregroundColor(.gray)
        }.bold()
            .padding(.horizontal, 24)
    }
}

#Preview {
    SectionHeader(title: "별점", rating: "4.5(9)")
}
