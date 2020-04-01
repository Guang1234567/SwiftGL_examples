// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "CGLFW3",
    products: [
        .library(name: "GLFW3", type: .dynamic, targets: ["GLFW3"]),
    ],
    targets: [
        .systemLibrary(
            name: "CGLFW3",
            providers: [
                .brew(["glfw"]),
                .apt(["glfw"]),
            ]
        ),
        .target(
            name: "GLFW3",
            dependencies: ["CGLFW3"]
        ),
    ]
)
