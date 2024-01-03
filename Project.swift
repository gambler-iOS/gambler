import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "gambler",
    platform: .iOS,
    product: .app,
    packages: [
        .remote(
            url: "https://github.com/kakao/kakao-ios-sdk",
            requirement: .upToNextMajor(from: "2.20.0")
        ),
        .remote(
            url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM",
            requirement: .upToNextMajor(from: "2.0.0")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher.git",
            requirement: .upToNextMajor(from: "7.10.1")
        ),
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk",
            requirement: .upToNextMajor(from: "10.19.1")
        ),
        .remote(
            url: "https://github.com/Alamofire/Alamofire",
            requirement: .upToNextMajor(from: "5.8.1")
        ),
        .remote(
            url: "https://github.com/SwiftyJSON/SwiftyJSON",
            requirement: .upToNextMajor(from: "5.0.1")
        )
    ],
    dependencies: [
        .package(product: "Alamofire"),
        .package(product: "firebase-ios-sdk"),
        .package(product: "KakaoMapsSDK-SPM"),
        .package(product: "kakao-ios-sdk"),
        .package(product: "Kingfisher"),
        .package(product: "SwiftyJSON")
    ],
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
//    ,entitlements: "gambler.entitlements"
)
