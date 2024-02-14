//
//  ReportView.swift
//  gambler
//
//  Created by 박성훈 on 2/13/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct ReportView: View {
    enum ReportingItems: CaseIterable {
        case spam
        case paidAds
        case falseInformation
        case harassmentOrPrivacyViolations
        case adultContent
        case otehr
        
        var reportingName: String {
            switch self {
            case .spam:
                return "스팸"
            case .paidAds:
                return "유료 광고 포함"
            case .falseInformation:
                return "거짓 정보"
            case .harassmentOrPrivacyViolations:
                return "괴롭힘 또는 개인정보 침해"
            case .adultContent:
                return "성인용 컨텐츠"
            case .otehr:
                return "기타"
            }
        }
    }
    
    @State private var reportingReason: String = ReportingItems.spam.reportingName
    @State private var isClickedButton: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("무슨 일인가요?")
            Text("확인 후 이메일로 회신 드리고 있습니다!")
            
            Text("항목")
            
            Button {
                isClickedButton.toggle()
            } label: {
                HStack {
                    Text(reportingReason)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: isClickedButton ? "chevron.down" : "chevron.up")
                        .foregroundStyle(Color.black)
                }
                .padding()
                .background(Color.secondary)
            }
            
            ZStack {
                ReportContentView()
                    .frame(height: 200)
                
                if isClickedButton {
                    VStack {
                        ForEach(ReportingItems.allCases, id: \.self) { item in
                            Button {
                                reportingReason = item.reportingName
                                isClickedButton.toggle()
                            } label: {
                                Text(item.reportingName)
                            }
                        }
                    }
                }
            }
            
            // 사진 추가 까지~~
            
            Button {
                /*
                 1. 파이어베이스에 올림
                 2. 알럿을 띄워서 신고하시겠습니까 문구
                 3. 알럿에서 확인을 누르면 신고하기에서 나가서 마이페이지로 감
                 */
            } label: {
                Text("작성 완료")
            }
        }
        .navigationTitle("고객센터")
    }
}

#Preview {
    ReportView()
}
