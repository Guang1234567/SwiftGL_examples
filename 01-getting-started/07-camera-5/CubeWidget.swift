import Foundation
import SGLOpenGL
import SGLObjects
import SGLImage
import SGLMath

class CubeWidget {
    let mRenderObject: RenderObject

    var mTranslateMat4: mat4
    var mRotateMat4: mat4
    var mScaleMat4: mat4

    init(renderObject: RenderObject) {
        mRenderObject = renderObject

        mTranslateMat4 = mat4()
        mRotateMat4 = mat4()
        mScaleMat4 = mat4()
    }

    init(shader: Shader) {
        let vd: VerticesDescription = VerticesDescription(
                vertices: vertices,
                stride: 5,
                usage: GL_DYNAMIC_DRAW,
                attribDescription: [
                    VertexAttribDescription(index: 0, size: 3, normalized: false, stride: 5, offset: 0),
                    VertexAttribDescription(index: 1, size: 2, normalized: false, stride: 5, offset: 3)
                ]
        )

        let tds: [Texture2DDescription] = [
            Texture2DDescription(
                    texture2D: Texture2D(format: GL_RGB, filePath: "container.png"),
                    textureIndex: GL_TEXTURE0,
                    shaderVarName: "ourTexture1"
            ),
            Texture2DDescription(
                    texture2D: Texture2D(format: GL_RGBA, filePath: "awesomeface.png"),
                    textureIndex: GL_TEXTURE1,
                    shaderVarName: "ourTexture2"
            )
        ]

        mRenderObject = RenderObject(
                verticesDescription: vd,
                texture2DDescriptions: tds,
                shader: shader
        )

        mTranslateMat4 = mat4()
        mRotateMat4 = mat4()
        mScaleMat4 = mat4()
    }

    func draw(parentModel: mat4) {
        var model = mTranslateMat4 * mRotateMat4 * mScaleMat4 * parentModel
        mRenderObject.draw(model: &model)
    }

    func moveTo(x: GLfloat, y: GLfloat, z: GLfloat) {
        mTranslateMat4 = SGLMath.translate(mat4(), [x, y, z])
    }

    func moveTo(xyz: vec3) {
        mTranslateMat4 = SGLMath.translate(mat4(), xyz)
    }

    func moveBy(x: GLfloat, y: GLfloat, z: GLfloat) {
        mTranslateMat4 = SGLMath.translate(mTranslateMat4, [x, y, z])
    }

    func moveBy(xyz: vec3) {
        mTranslateMat4 = SGLMath.translate(mTranslateMat4, xyz)
    }

    func rotateTo(radian angle: GLfloat, centerAxis: vec3) {
        mRotateMat4 = SGLMath.rotate(mat4(), angle, centerAxis)
    }

    func rotateTo(degree angle: GLfloat, centerAxis: vec3) {
        mRotateMat4 = SGLMath.rotate(mat4(), radians(angle), centerAxis)
    }

    func rotateBy(radian angle: GLfloat, centerAxis: vec3) {
        mRotateMat4 = SGLMath.rotate(mRotateMat4, angle, centerAxis)
    }

    func rotateBy(degree angle: GLfloat, centerAxis: vec3) {
        mRotateMat4 = SGLMath.rotate(mRotateMat4, radians(angle), centerAxis)
    }

    func scaleTo(sx: GLfloat, sy: GLfloat, sz: GLfloat) {
        mScaleMat4 = SGLMath.scale(mat4(), [sx, sy, sz])
    }

    func scaleTo(sxyz: vec3) {
        mScaleMat4 = SGLMath.scale(mat4(), sxyz)
    }

    func scaleTo(same: GLfloat) {
        mScaleMat4 = SGLMath.scale(mat4(), [same, same, same])
    }

    func scaleBy(sx: GLfloat, sy: GLfloat, sz: GLfloat) {
        mScaleMat4 = SGLMath.scale(mScaleMat4, [sx, sy, sz])
    }

    func scaleBy(sxyz: vec3) {
        mScaleMat4 = SGLMath.scale(mScaleMat4, sxyz)
    }

    func scaleBy(same: GLfloat) {
        mScaleMat4 = SGLMath.scale(mScaleMat4, [same, same, same])
    }

    public func clone() -> CubeWidget {
        CubeWidget(renderObject: mRenderObject)
    }
}
