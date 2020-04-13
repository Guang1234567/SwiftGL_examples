import Foundation
import SGLOpenGL
import SGLObjects
import SGLImage
import SGLMath

class ObjectCubeWidget: BaseWidget {

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
                    {
                        $0.setVec3(name: "objectColor", x: 1.0, y: 0.5, z: 0.31)
                        //var coral: vec3 = vec3(1.0, 0.5, 0.31)
                        //$0.setVec3(name: "objectColor", value: &coral)
                        $0.setVec3(name: "lightColor", x: 1.0, y: 1.0, z: 1.0)
                    }
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
        ObjectCubeWidget(renderObject: mRenderObject)
    }
}
