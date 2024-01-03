//
//  Dependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by cha_nyeong on 12/26/23.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let Alamofire = TargetDependency.external(name: "Alamofire")
    static let FirebaseAuth = TargetDependency.external(name: "FirebaseAuth")
    static let FirebaseStorage = TargetDependency.external(name: "FirebaseStorage")
    static let FirebaseFirestore = TargetDependency.external(name: "FirebaseFirestore")
    static let KakaoMapsSDK = TargetDependency.external(name: "KakaoMapsSDK_SPM")
    static let SwiftyJSON = TargetDependency.external(name: "SwiftyJSON")
}

