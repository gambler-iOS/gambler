//
//  Project.swift
//  AppManifests
//
//  Created by cha_nyeong on 12/25/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "gambler",
    platform: .iOS,
    product: .app,
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "10.4.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.8.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .upToNextMajor(from: "4.0.0")),
    ],
    dependencies: [
        .package(product: "Alamofire"),
        .package(product: "Kingfisher"),
        .package(product: "SwiftyJSON"),
        .package(product: "KakaoMapsSDK_SPM"),
        .package(product: "FirebaseAuth"),
        .package(product: "FirebaseStorage"),
        .package(product: "FirebaseFirestore"),
        .package(product: "FirebaseFirestoreSwift"),
        .package(product: "FirebaseMessaging"),
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Resources/gambler-Info.plist"),
    entitlements: "gambler.entitlements"
)
