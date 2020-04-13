import Foundation
import SGLOpenGL
import SGLObjects
import SGLImage
import SGLMath

class LampCubeWidget: BaseWidget {

    /*
    convenience init(shader: Shader) {
        let vbo: VBO = VBO(
                size: 1,
                vertices: vertices,
                usage: GL_DYNAMIC_DRAW
        ) {
            $0.vertexAttribPointer(
                    index: 0,
                    size: 3,
                    normalized: false,
                    stride: 3,
                    offset: 0)
        }

        let tds: [Texture2DDescription] = []

        let sds: ShaderDescription = ShaderDescription(
                shader: shader,
                actions: [
                ]
        )

        self.init(renderObject: RenderObject(
                vbo: vbo,
                texture2DDescriptions: tds,
                shaderDescription: sds
        ))
    }
    */

    override func clone() -> BaseWidget {
        LampCubeWidget(renderObject: mRenderObject)
    }
}
