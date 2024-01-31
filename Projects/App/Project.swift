//
//  Project.swift
//  AppManifests
//
//  Created by cha_nyeong on 12/25/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

var extendedInfoPlist: [String: Plist.Value] = [
    "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
    "NSLocationWhenInUseUsageDescription": "위치 정보를 사용하시겠습니까?"
]
let project = Project.makeModule(
    name: "gambler",
    platform: .iOS,
    product: .app,
    packages: [
    ],
    dependencies: [
//        .project(target: "Coordinator", path: .relativeToRoot("Projects/Coordinator")),
//        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
//        .project(target: "Core", path: .relativeToRoot("Projects/Core")),
//        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .SPM.Alamofire,
        .SPM.Kingfisher,
        .SPM.SwiftyJSON,
        .SPM.KakaoMapsSDK_SPM,
        .SPM.FirebaseAuth,
        .SPM.FirebaseStorage,
        .SPM.FirebaseFirestore,
        .SPM.FirebaseFirestoreSwift,
        .SPM.FirebaseMessaging
    ],
    resources: ["Resources/**"],
    infoPlist: .extendingDefault(with: extendedInfoPlist), // .file(path: "Support/Info.plist"),
    entitlements: "gambler.entitlements"
)
