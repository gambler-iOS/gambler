//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by cha_nyeong on 12/24/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DesignSystem",
    product: .staticFramework,
    dependencies: [
//        .SPM.,
//        .SPM.Kingfisher
    ],
    resources: ["Resources/**"]
)
