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
    infoPlist: .file(path: "Resources/gambler-Info.plist"),
    entitlements: "gambler.entitlements"
)
