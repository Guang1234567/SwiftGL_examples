import Foundation
import SGLOpenGL
import SGLObjects
import SGLImage
import SGLMath

open class BaseWidget {
    let mRenderObject: RenderObject

    var mTranslateMat4: mat4
    var mRotateMat4: mat4
    var mScaleMat4: mat4

    var x: GLfloat {
        mTranslateMat4[3].x
    }

    var y: GLfloat {
        mTranslateMat4[3].y
    }

    var z: GLfloat {
        mTranslateMat4[3].z
    }

    var xyz: vec3 {
        vec3(mTranslateMat4[3])
    }

    init(renderObject: RenderObject) {
        mRenderObject = renderObject

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

    public func clone() -> BaseWidget {
        BaseWidget(renderObject: mRenderObject)
    }
}
