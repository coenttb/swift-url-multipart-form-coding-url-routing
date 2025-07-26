// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let multipartURLFormCoding: Self = "URLMultipartFormCoding"
    static let multipartURLFormCodingURLRouting: Self = "URLMultipartFormCodingURLRouting"
}

extension Target.Dependency {
    static var multipartURLFormCoding: Self { .target(name: .multipartURLFormCoding) }
    static var multipartURLFormCodingURLRouting: Self { .target(name: .multipartURLFormCodingURLRouting) }
}

extension Target.Dependency {
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var parsing: Self { .product(name: "Parsing", package: "swift-parsing") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding") }
}

let package = Package(
    name: "swift-url-multipart-form-coding-url-routing",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
//        This library is intended to me moved to a separate swift-url-multipart-form-coding package
//        .library(name: .multipartURLFormCoding, targets: [.multipartURLFormCoding]),
        .library(name: .multipartURLFormCodingURLRouting, targets: [.multipartURLFormCodingURLRouting]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-url-form-coding", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
    ],
    targets: [
        .target(
            name: .multipartURLFormCoding,
            dependencies: [
                .urlRouting,
                .urlFormCoding,
            ]
        ),
        .testTarget(
            name: .multipartURLFormCoding.tests,
            dependencies: [
                .multipartURLFormCoding,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .multipartURLFormCodingURLRouting,
            dependencies: [
                .multipartURLFormCoding,
                .urlRouting,
                .urlFormCoding,
            ]
        ),
        .testTarget(
            name: .multipartURLFormCodingURLRouting.tests,
            dependencies: [
                .multipartURLFormCodingURLRouting,
                .dependenciesTestSupport
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String { var tests: Self { self + " Tests" } }
