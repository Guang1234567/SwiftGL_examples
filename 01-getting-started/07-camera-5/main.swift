// License: http://creativecommons.org/publicdomain/zero/1.0/

// Import the required libraries

import CGLFW3
import SGLOpenGL
import SGLObjects
import SGLImage
import SGLMath
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

// Window dimensions
let WIDTH: GLsizei = 800, HEIGHT: GLsizei = 600

// Camera
var cameraPos = vec3(0.0, 0.0, 3.0)
var cameraFront = vec3(0.0, 0.0, -1.0)
var cameraUp = vec3(0.0, 1.0, 0.0)
// Yaw is initialized to -90.0 degrees since a yaw of 0.0 results in a
// direction vector pointing to the right (due to how Euler angles work)
// so we initially rotate a bit to the left.
var yaw = GLfloat(-90.0)
var pitch = GLfloat(0.0)
var lastX = GLfloat(WIDTH) / 2.0
var lastY = GLfloat(HEIGHT) / 2.0
var fov = GLfloat(45.0)
var keys = [Bool](repeating: false, count: Int(GLFW_KEY_LAST) + 1)

// Deltatime
var deltaTime = GLfloat(0.0)  // Time between current frame and last frame
var lastFrame = GLfloat(0.0)  // Time of last frame


func keyCallback(window: OpaquePointer!, key: Int32, scancode: Int32, action: Int32, mode: Int32) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE)
    }
    if key >= 0 && Int(key) < keys.count {
        if action == GLFW_PRESS {
            keys[Int(key)] = true
        } else if action == GLFW_RELEASE {
            keys[Int(key)] = false
        }
    }
}


func doMovement() {
    // Camera controls
    let cameraSpeed = 5.0 * deltaTime
    if keys[Int(GLFW_KEY_W)] {
        cameraPos += cameraSpeed * cameraFront
    }
    if keys[Int(GLFW_KEY_S)] {
        cameraPos -= cameraSpeed * cameraFront
    }
    if keys[Int(GLFW_KEY_A)] {
        cameraPos -= normalize(cross(cameraFront, cameraUp)) * cameraSpeed
    }
    if keys[Int(GLFW_KEY_D)] {
        cameraPos += normalize(cross(cameraFront, cameraUp)) * cameraSpeed
    }
}


var firstMouse = true

func mouseCallback(window: OpaquePointer!, xpos: Double, ypos: Double) {
    if firstMouse {
        lastX = Float(xpos)
        lastY = Float(ypos)
        firstMouse = false
    }

    var xoffset = Float(xpos) - lastX
    var yoffset = lastY - Float(ypos)
    lastX = Float(xpos)
    lastY = Float(ypos)

    let sensitivity = GLfloat(0.05)  // Change this value to your liking
    xoffset *= sensitivity
    yoffset *= sensitivity

    yaw += xoffset
    pitch += yoffset

    // Make sure that when pitch is out of bounds, screen doesn't get flipped
    if (pitch > 89.0) {
        pitch = 89.0
    }
    if (pitch < -89.0) {
        pitch = -89.0
    }

    var front = vec3()
    front.x = cos(radians(yaw)) * cos(radians(pitch))
    front.y = sin(radians(pitch))
    front.z = sin(radians(yaw)) * cos(radians(pitch))
    cameraFront = normalize(front)
}


func scrollCallback(window: OpaquePointer!, xoffset: Double, yoffset: Double) {
    if (fov >= 1.0 && fov <= 45.0) {
        fov -= Float(yoffset)
    }
    if fov <= 1.0 {
        fov = 1.0
    }
    if fov >= 45.0 {
        fov = 45.0
    }
}

// The *main* function; where our program begins running
func main() {
    print("Starting GLFW context, OpenGL 3.3")
    // Init GLFW
    glfwInit()
    // Terminate GLFW when this function ends
    defer {
        glfwTerminate()
    }

    // Set all the required options for GLFW
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE)
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)

    // Create a GLFWwindow object that we can use for GLFW's functions
    let window = glfwCreateWindow(WIDTH, HEIGHT, "LearnSwiftGL", nil, nil)
    glfwMakeContextCurrent(window)
    guard window != nil else {
        print("Failed to create GLFW window")
        return
    }

    // Set the required callback functions
    glfwSetKeyCallback(window, keyCallback)
    glfwSetCursorPosCallback(window, mouseCallback)
    glfwSetScrollCallback(window, scrollCallback)

    // GLFW Options
    glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED)

    let ourShader = Shader(vertexFile: "shader.vs", fragmentFile: "shader.frag")

    // Define the viewport dimensions
    glViewport(x: 0, y: 0, width: WIDTH, height: HEIGHT)

    let cubePositions: [vec3] = [
        [0.0, 0.0, 0.0],
        [2.0, 5.0, -15.0],
        [-1.5, -2.2, -2.5],
        [-3.8, -2.0, -12.3],
        [2.4, -0.4, -3.5],
        [-1.7, 3.0, -7.5],
        [1.3, -2.0, -2.5],
        [1.5, 2.0, -2.5],
        [1.5, 0.2, -1.5],
        [-1.3, 1.0, -1.5]
    ]

    let cubeWidgetDemo = CubeWidget(shader: ourShader);
    var cubeWidgets: [CubeWidget] = []
    for (index, cubePosition) in cubePositions.enumerated() {
        let cubeWidget = cubeWidgetDemo.clone()
        cubeWidget.moveBy(xyz: cubePosition)
        //cubeWidget.rotateBy(degree: GLfloat(index) * 16.0, centerAxis: vec3(1.0, 0.0, 0.0))

        cubeWidgets.append(cubeWidget)
    }

    // Setup OpenGL options
    glEnable(GL_DEPTH_TEST)

    // Game loop
    while glfwWindowShouldClose(window) == GL_FALSE {
        // Calculate deltatime of current frame
        let currentFrame = GLfloat(glfwGetTime())
        deltaTime = currentFrame - lastFrame
        lastFrame = currentFrame

        // Check if any events have been activated
        // (key pressed, mouse moved etc.) and call
        // the corresponding response functions
        glfwPollEvents()
        doMovement()

        // Render
        // Clear the colorbuffer
        glClearColor(red: 0.2, green: 0.3, blue: 0.3, alpha: 1.0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        // Create transformations
        var view = SGLMath.lookAt(cameraPos, cameraPos + cameraFront, cameraUp)
        let aspectRatio = GLfloat(WIDTH) / GLfloat(HEIGHT)
        var projection = SGLMath.perspective(radians(fov), aspectRatio, 0.1, 100.0)
        ourShader.setMatrix(name: "view", transpose: false, value: &view)
        ourShader.setMatrix(name: "projection", transpose: false, value: &projection)
        let model = mat4()

        // Draw container
        for (index, cubeWidget) in cubeWidgets.enumerated() {
            let angle = GLfloat(index * 20) * deltaTime
            cubeWidget.rotateBy(degree: angle, centerAxis: vec3(1.0, 0.3, 0.5))
            cubeWidget.draw(parentModel: model)
        }

        // Swap the screen buffers
        glfwSwapBuffers(window)
    }
}


// Start the program with function main()
main()
