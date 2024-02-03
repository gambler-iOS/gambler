//
//  SummaryReviewView.swift
//  gambler
//
//  Created by daye on 2/3/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct SummaryReviewView: View {
    var review: Review?
    var rating: String = "4.5"
    var reviewNum: Int = 10
    public var testImage: String = "https://search.pstatic.net/common/?src=https%3A%2F%2Fldb-phinf.pstatic.net%2F20201221_142%2F1608531845610Jg8jX_JPEG%2FFlbld1H3ZDskqlZNz7t6Kk4_.jpg"
    
    var body: some View {
        VStack{
            HStack{
                Text("리뷰 \(rating)(\(reviewNum))")
                    .font(.title3)
                Spacer()
                Image(systemName: "greaterthan")
                    .foregroundColor(.gray)
            }.bold()
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(1..<10) { index in
                        // 수평으로 배치될 각 페이지
                        Rectangle()
                            .frame(width: 250, height: 90)
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .cornerRadius(10)
                            .padding(1)
                            .overlay {
                                ReviewPreview(testImage: testImage)
                            }
                    }
                }
                .padding(.leading, 30)
            }
        }.padding(.bottom, 10)
    }
    
    private struct ReviewPreview: View {
        var testImage: String
        var body: some View {
            HStack{
                AsyncImage(url: URL(string: testImage)) { image in
                    image
                        .resizable()
                        .frame(width:60, height:60)
                        .cornerRadius(10)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                VStack(alignment: .leading){
                    HStack{
                        Group {
                            Image(systemName: "star.fill")
                            Text("3")
                        }
                    }.foregroundStyle(.pink)
                        .padding(.bottom, 5)
                    Text("후기가어쭈거ㅜ어ㅝㅜ우너ㅝㅇㄴㅇㄴ언ㅇㄴ어루눌ㅇ넝ㄹ눨ㅇㄴㄹㅇ너ㅜㄹ운ㄹ웅ㄹ눨ㅇ널ㅇ누렁ㄴ")
                }.font(.caption2)
                    .padding(5)
            }.padding(10)
        }
    }
}

#Preview {
    SummaryReviewView()
}
