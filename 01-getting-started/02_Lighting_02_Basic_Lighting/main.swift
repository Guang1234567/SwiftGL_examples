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
var cameraPos = vec3(0.0, 0.0, 6.0)
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


var lightPos: vec3 = [2.0, 0.0, 2.0]


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
    //glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED)

    let objectShader = Shader(vertexFile: "object_shader.vs", fragmentFile: "object_shader.frag")
    let objectGouraudShader = Shader(vertexFile: "object_shader_gouraud.vs", fragmentFile: "object_shader_gouraud.frag")
    let lampShader = Shader(vertexFile: "lamp_shader.vs", fragmentFile: "lamp_shader.frag")

    // Define the viewport dimensions
    glViewport(x: 0, y: 0, width: WIDTH, height: HEIGHT)

    let vbo: VBO = VBO(
            size: 1,
            vertices: vertices,
            usage: GL_DYNAMIC_DRAW) {

        $0.vertexAttribPointer(
                index: 0,
                size: 3,
                normalized: false,
                stride: 6,
                offset: 0)

        $0.vertexAttribPointer(
                index: 1,
                size: 3,
                normalized: false,
                stride: 6,
                offset: 3)
    }

    let tds: [Texture2DDescription] = []

    let lampSds: ShaderDescription = ShaderDescription(
            shader: lampShader,
            actions: [
            ]
    )

    let lampCubeWidget = LampCubeWidget(renderObject: RenderObject(
            vbo: vbo,
            texture2DDescriptions: tds,
            shaderDescription: lampSds
    ));
    lampCubeWidget.moveTo(xyz: lightPos)
    lampCubeWidget.scaleTo(same: 0.2)

    let objectSds: ShaderDescription = ShaderDescription(
            shader: objectShader,
            actions: [
                {
                    $0.setVec3(name: "objectColor", x: 1.0, y: 0.5, z: 0.31)
                    //var coral: vec3 = vec3(1.0, 0.5, 0.31)
                    //$0.setVec3(name: "objectColor", value: &coral)
                    $0.setVec3(name: "lightColor", x: 1.0, y: 1.0, z: 1.0)

                    var currentLampPos = lampCubeWidget.xyz
                    $0.setVec3(name: "lightPos", value: &currentLampPos);
                    $0.setVec3(name: "viewPos", value: &cameraPos)
                }
            ]
    )

    let objectCubeWidget = ObjectCubeWidget(renderObject: RenderObject(
            vbo: vbo,
            texture2DDescriptions: tds,
            shaderDescription: objectSds
    ));
    objectCubeWidget.moveTo(x: -1, y: 0.0, z: 0.0)

    let object2Sds: ShaderDescription = ShaderDescription(
            shader: objectGouraudShader,
            actions: [
                {
                    $0.setVec3(name: "objectColor", x: 1.0, y: 0.5, z: 0.31)
                    //var coral: vec3 = vec3(1.0, 0.5, 0.31)
                    //$0.setVec3(name: "objectColor", value: &coral)
                    $0.setVec3(name: "lightColor", x: 1.0, y: 1.0, z: 1.0)

                    var currentLampPos = lampCubeWidget.xyz
                    $0.setVec3(name: "lightPos", value: &currentLampPos);
                    $0.setVec3(name: "viewPos", value: &cameraPos)
                }
            ]
    )
    //let objectCubeWidget2 = objectCubeWidget.clone()
    let objectCubeWidget2 = ObjectCubeWidget(renderObject: RenderObject(
            vbo: vbo,
            texture2DDescriptions: tds,
            shaderDescription: object2Sds
    ));
    objectCubeWidget2.moveTo(x: -objectCubeWidget.x, y: objectCubeWidget.y, z: objectCubeWidget.z)

    var cubeWidgets: [BaseWidget] = []
    cubeWidgets.append(lampCubeWidget)
    cubeWidgets.append(objectCubeWidget)
    cubeWidgets.append(objectCubeWidget2)

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
        let model = mat4()
        var view = SGLMath.lookAt(cameraPos, cameraPos + cameraFront, cameraUp)
        let aspectRatio = GLfloat(WIDTH) / GLfloat(HEIGHT)
        var projection = SGLMath.perspective(radians(fov), aspectRatio, 0.1, 100.0)

        objectGouraudShader.use()
        objectGouraudShader.setMat4(name: "view", transpose: false, value: &view)
        objectGouraudShader.setMat4(name: "projection", transpose: false, value: &projection)

        objectShader.use()
        objectShader.setMat4(name: "view", transpose: false, value: &view)
        objectShader.setMat4(name: "projection", transpose: false, value: &projection)

        lampShader.use()
        lampShader.setMat4(name: "view", transpose: false, value: &view)
        lampShader.setMat4(name: "projection", transpose: false, value: &projection)

        let radius: GLfloat = 2.0;
        let lampX: GLfloat = sin(currentFrame) * radius;
        let lampZ: GLfloat = cos(currentFrame) * radius;
        lampCubeWidget.moveTo(x: lampX, y: lightPos.y, z: lampZ)

        // Draw container
        for (index, cubeWidget) in cubeWidgets.enumerated() {
            let angle = GLfloat(index * 10) * deltaTime
            //cubeWidget.rotateBy(degree: index % 2 == 0 ? -angle : angle, centerAxis: vec3(1.0, 0.3, 0.5))
            cubeWidget.draw(parentModel: model)
        }

        // Swap the screen buffers
        glfwSwapBuffers(window)
    }
}


// Start the program with function main()
main()
