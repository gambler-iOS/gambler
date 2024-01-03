//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by cha_nyeong on 12/11/23.
//

import ProjectDescription

public extension TargetScript {

    static let SwiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell",
        basedOnDependencyAnalysis: false
    )
    
}
