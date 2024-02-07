//
//  SummaryReviewView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher

struct SummaryReviewView: View {
    var review: Review?
    var rating: String = "4.5"
    var reviewNum: Int = 10
    public var testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    
    var body: some View {
        VStack{
    
            SectionHeader(title: "리뷰", rating: "\(rating)(\(reviewNum))")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(1..<10) { index in
                        Rectangle()
                            .frame(width: 250, height: 90)
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .cornerRadius(10)
                            .padding(1)
                            .overlay {
                                ReviewPreview(testImage: testImage)
                            }
                    }
                }.padding()
            }.padding(.leading, 16)
        }
           .padding(.vertical, 25)
    }
    
    struct ReviewPreview: View {
        var testImage: String
        var body: some View {
            HStack{
                KFImage(URL(string: testImage))
                    .resizable()
                    .frame(width:60, height:60)
                    .cornerRadius(10)
                    .clipped()
                
                VStack(alignment: .leading){
                    HStack{
                        Group {
                            Image(systemName: "star.fill")
                            Text("3")
                        }
                    }.foregroundStyle(.pink)
                        .padding(.bottom, 5)
                    Text("후기가Wㅜ구ㅜ구구구dasdsdsdsssㅜ국")
                }.font(.caption2)
                    .padding(10)
            }.padding()
        }
    }
}

#Preview {
    SummaryReviewView()
}
