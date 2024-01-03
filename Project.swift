//
//  Project.swift
//  AppManifests
//
//  Created by cha_nyeong on 12/25/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "gambler"

let config = Settings.settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Configs/Secrets.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Configs/Secrets.xcconfig")),
])

let project = Project.makeModule(
    name: "gambler",
    platform: .iOS,
    product: .app,
    packages: [
    ],
    settings: config,
    dependencies: [
        .SPM.Kingfisher,
        .SPM.Alamofire,
        .SPM.FirebaseAuth,
        .SPM.FirebaseStorage,
        .SPM.FirebaseFirestore,
        .SPM.KakaoMapsSDK,
        .SPM.SwiftyJSON
    ],
    resources: ["Gambler/Resources/**"],
    infoPlist: .default,
    entitlements: "gambler.entitlements"
    
 
)



