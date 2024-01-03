//
//  Dependencies.swift
//  Config
//
//  Created by Hyo Myeong Ahn on 12/29/23.
//

import ProjectDescription

/*
 2023.12.26 우선적으로 정해진 사용할 라이브러리
    Firebase
    Alamofire
    Kingfisher
    SwiftLint
    KakaoMap (daum map)
    SwiftyJSON
*/

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.4.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.8.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .upToNextMajor(from: "4.0.0")),
    ],
    platforms: [.iOS]
)
