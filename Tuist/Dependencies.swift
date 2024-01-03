//
//  Dependency.swift
//  Config
//
//  Created by 박성훈 on 12/31/23.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies([
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "5.15.6")),
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.8.1")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.4.0")),
        .remote(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .upToNextMajor(from: "4.0.0"))
    ]),
    platforms: [.iOS]
)
