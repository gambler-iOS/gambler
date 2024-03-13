//
//  ProfileEditView.swift
//  gambler
//
//  Created by daye on 2/29/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI

struct CustomerServiceView: View {
    let complainViewModel: ComplainViewModel = ComplainViewModel()
    @State private var choiceCategory: ComplainCategory = .spam
    @State private var isShowingDropMenu = false
    @State private var serviceContent: String = ""
    @State private var disabledButton: Bool = true
    @State private var selectedPhotosData: [Data] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading, spacing: .zero) {
                titleView
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                complainTitleView(image:
                                    isShowingDropMenu ?
                                  GamblerAsset.arrowDown.swiftUIImage : GamblerAsset.arrowUp.swiftUIImage)
                .onTapGesture {
                    isShowingDropMenu.toggle()
                }
                TextEditorView(text: $serviceContent, placeholder: "내용을 적어주세요")
                    .padding(.top, 16)
                AddImageView(selectedPhotosData: $selectedPhotosData, topPadding: .constant(16))
                Spacer()
                CTAButton(disabled: $disabledButton, title: "완료") {
                    print("완료 버튼 눌림")
                    Task {
                        await complainViewModel.addData(complain: Complain(id: UUID().uuidString,
                                                                           complainCategory: choiceCategory,
                                                                           complainContent: serviceContent,
                                                                           complainImage: 
                                                                            try await ImageUploader.uploadCustomerServiceImage(selectedPhotosData, 
                                                                                                                               type: .customerService),
                                                                           createdDate: Date()))
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.bottom, 24)
            }
            .background {
                Color.white
                    .onTapGesture {
                        isShowingDropMenu = false
                    }
            }
            .onReceive([self.serviceContent].publisher.first()) { _ in
                self.updateDisabledButton()
            }
            .padding(.horizontal, 24)
            .navigationTitle("고객 센터")
            .modifier(BackButton())
            .overlay(content: {
                if isShowingDropMenu {
                    DropDownMemuView(isShowingDropMenu: $isShowingDropMenu, choiceCategory: $choiceCategory)
                        .padding(.top, 50)
                        .padding(.horizontal, 23)
                    
                }
            })
        }
        
    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("무슨 일인가요?")
                .font(.head2B)
            Text("확인 후 이메일로 회신 드리고 있습니다!")
                .font(.caption1M)
                .foregroundStyle(Color.gray300)
                .padding(.top, 10)
        }
    }
    
    private func complainTitleView(image: Image) -> some View {
        TitleAndBoxView(title: "항목")
            .padding(.vertical, 16)
            .overlay {
                HStack {
                    Text(choiceCategory.complainName)
                        .font(.body1M)
                        .foregroundStyle(Color.gray700)
                    Spacer()
                    image
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(height: 56)
                .padding(.top, 28)
                .padding(.horizontal, 16)
            }
    }
    
    private func updateDisabledButton() {
        if !serviceContent.isEmpty {
            disabledButton = false
        } else {
            disabledButton = true
        }
    }
}

#Preview {
    CustomerServiceView()
}
