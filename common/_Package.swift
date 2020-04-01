// swift-tools-version:5.0

import PackageDescription

let package = Package(
        name: "example",
        products: [
            .executable(name: "example", targets: ["example"]),
        ],
        dependencies: [
            //.package(url: "https://github.com/SwiftGL/OpenGL.git", from: "3.0.0"),
            //.package(url: "https://github.com/Guang1234567/Swift_OpenGL.git", .branch("gles32_egl15_android")),
            .package(path: "/Users/lihanguang/dev_kit/sdk/swift_source/readdle/Swift_OpenGL"),
            //.package(url: "https://github.com/SwiftGL/Math.git", from: "2.0.0"),
            .package(url: "https://github.com/Guang1234567/SGLMath.git", .branch("master")),
            //.package(url: "https://github.com/SwiftGL/Image.git", from: "2.0.0"),
            .package(url: "https://github.com/Guang1234567/SGLImage.git", .branch("master")),
            //.package(url: "https://github.com/SwiftGL/CGLFW3.git", from: "2.0.0"),
            //.package(url: "../../common/CGLFW3", .branch("master")),
            .package(path: "../../common/CGLFW3"),
        ],
        targets: [
            .target(
                    name: "example",
                    dependencies: ["SGLMath", "SGLImage", "SGLOpenGL", "SGLObjects", "GLFW3"],
                    path: ".",
                    linkerSettings: [
                        .unsafeFlags(["-I/usr/local/include", "-L/usr/local/lib"], .when(platforms: [.macOS, .linux]))
                    ]
            )
        ]
)
