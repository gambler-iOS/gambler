//
//  TermsOfUseView.swift
//  gambler
//
//  Created by 박성훈 on 2/17/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct TermsOfUseView: View {
    let description: [String: [String]] = ["제 1장": ["1. 겜블러는","2.","3."], "제 2장": ["1."] ]
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        Text("이용약관 동의")
                            .padding(.top, 6)
                            .font(.subHead2B)
                        ForEach(description.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text(key)
                                .padding(.top, 23)
                                .padding(.bottom, 10)
                                .font(.subHead2B)
                            ForEach(value, id: \.self) { item in
                                Text(item)
                                    .font(.caption1M)
                            }
                        }
                    }
                }.padding(24)
                Spacer()
            }
            
        } .modifier(BackButton())
    }

    
    
    private var termsOfUserCellView: some View {
        VStack(alignment: .leading) {
            Text("이용약관 동의")
                .padding(.top, 6)
                .font(.subHead2B)
            ForEach(description.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text(key)
                    .padding(.top, 23)
                    .padding(.bottom, 10)
                    .font(.subHead2B)
                ForEach(value, id: \.self) { item in
                    Text(item)
                        .font(.caption1M)
                }
            }
        }.background{
            Color.clear
        }
    }
}

#Preview {
    TermsOfUseView()
}
