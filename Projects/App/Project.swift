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
        .project(target: "Common", path: .relativeToRoot("Projects/Common")),
        .project(target: "Core", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist"),
    entitlements: "gambler.entitlements"
)
