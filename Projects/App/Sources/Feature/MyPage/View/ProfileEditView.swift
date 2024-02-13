//
//  ProfileEditView.swift
//  gambler
//
//  Created by 박성훈 on 1/27/24.
//  Copyright © 2024 gambler. All rights reserved.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ProfileEditView: View {
//    @EnvironmentObject var myPageViewModel: MyPageViewModel

    @State private var nickName: String = ""
    // 선택한 사진을 보관할 상태 변수를 선언
    @State private var selectedItem: PhotosPickerItem?
    // 데이터 객체를 보유하는 데 사용되는 또 다른 상태 변수
    @State private var selectedPhotoData: Data?
    
    @Binding var user: User
    
    var body: some View {
        VStack {
            if let selectedPhotoData,
               let image = UIImage(data: selectedPhotoData) {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(Circle())
            } else if let profileImage = user.profileImageURL {
                KFImage(URL(string: profileImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64, height: 64, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(.gray)
                    .clipShape(.circle)
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("프로필 사진 수정")
                    .padding(16)
                    .overlay(Capsule().stroke(.black))
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // 변경 사항이 있을 때마다 loadTransferable 메서드를 호출하여 에셋 데이터를 로드
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedPhotoData = data
                    }
                }
            }
            .padding(.bottom, 19)
            
            TextField("닉네임을 입력하세요", text: $nickName)
                .padding(16)
                .background(Color.secondary)
                .clipShape(.rect(cornerRadius: 8))
            
        }
        .onAppear {
            nickName = user.nickname
        }
        .navigationTitle("프로필 수정")
        .toolbar {
            Button {
                /*
                 1. 완료를 누른다.
                 2. Image Data를 Firebase Storage에 올린다.
                 3. Storage에 있는 주소를 user 변수에 ImageProfileURL 변수에 넣는다.
                 4. 닉네임이 변경되었다면 닉네임도 넣어준다.
                 5. Firebase에 Update 해준다.
                 6. 파이어베이스에서 해당 user의 데이터를 다시 읽어온다.
                 7. 해당 네비게이션을 빠져나온다.
                 */
            } label: {
                Text("완료")
            }

        }
    }
}

#Preview {
    ProfileEditView(user: .constant(User(nickname: "성훈",
                                         profileImageURL: "https://cdn-icons-png.flaticon.com/512/21/21104.png",
                                         apsToken: "카카오톡",
                                         createdDate: Date(),
                                         likeGameIds: [],
                                         likeShopIds: [])))
}
