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
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .exact("10.22.1")),
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.8.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", requirement: .upToNextMinor(from: "2.9.0")),
        .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.20.0")),
        .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/algolia/algoliasearch-client-swift", requirement: .exact("8.19.0")),
        .remote(url: "https://github.com/algolia/instantsearch-ios", requirement: .upToNextMajor(from: "7.26.1")),
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
        .package(product: "KakaoSDK"),
        .package(product: "GoogleSignIn"),
        .package(product: "AlgoliaSearchClient"),
        .package(product: "InstantSearch"),
        .package(product: "InstantSearchSwiftUI"),
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Resources/gambler-Info.plist"),
    entitlements: "gambler.entitlements"
)
