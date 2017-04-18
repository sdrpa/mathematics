/**
 Created by Sinisa Drpa on 2/24/17.

 Mathematics is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License or any later version.

 Mathematics is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Mathematics.  If not, see <http://www.gnu.org/licenses/>
 */

import Foundation

public struct Matrix4 {

    public var m11: Scalar
    public var m12: Scalar
    public var m13: Scalar
    public var m14: Scalar
    public var m21: Scalar
    public var m22: Scalar
    public var m23: Scalar
    public var m24: Scalar
    public var m31: Scalar
    public var m32: Scalar
    public var m33: Scalar
    public var m34: Scalar
    public var m41: Scalar
    public var m42: Scalar
    public var m43: Scalar
    public var m44: Scalar

    public init(m11: Scalar, m12: Scalar, m13: Scalar, m14: Scalar,
                m21: Scalar, m22: Scalar, m23: Scalar, m24: Scalar,
                m31: Scalar, m32: Scalar, m33: Scalar, m34: Scalar,
                m41: Scalar, m42: Scalar, m43: Scalar, m44: Scalar) {
        self.m11 = m11 // 0
        self.m12 = m12 // 1
        self.m13 = m13 // 2
        self.m14 = m14 // 3
        self.m21 = m21 // 4
        self.m22 = m22 // 5
        self.m23 = m23 // 6
        self.m24 = m24 // 7
        self.m31 = m31 // 8
        self.m32 = m32 // 9
        self.m33 = m33 // 10
        self.m34 = m34 // 11
        self.m41 = m41 // 12
        self.m42 = m42 // 13
        self.m43 = m43 // 14
        self.m44 = m44 // 15
    }
}

extension Matrix4: Equatable, Hashable {
    
    public static let identity = Matrix4(
        m11: 1, m12: 0, m13: 0, m14: 0,
        m21: 0, m22: 1, m23: 0, m24: 0,
        m31: 0, m32: 0, m33: 1, m34: 0,
        m41: 0, m42: 0, m43: 0, m44: 1)

    public var hashValue: Int {
        var hash = m11.hashValue &+ m12.hashValue &+ m13.hashValue &+ m14.hashValue
        hash = hash &+ m21.hashValue &+ m22.hashValue &+ m23.hashValue &+ m24.hashValue
        hash = hash &+ m31.hashValue &+ m32.hashValue &+ m33.hashValue &+ m34.hashValue
        hash = hash &+ m41.hashValue &+ m42.hashValue &+ m43.hashValue &+ m44.hashValue
        return hash
    }

    public static func scaled(by s: Vector3) -> Matrix4 {
        return Matrix4(
            m11: s.x, m12: 0,   m13: 0,   m14: 0,
            m21: 0,   m22: s.y, m23: 0,   m24: 0,
            m31: 0,   m32: 0,   m33: s.z, m34: 0,
            m41: 0,   m42: 0,   m43: 0,   m44: 1
        )
    }

    public static func translated(by t: Vector3) -> Matrix4 {
        return Matrix4(
            m11: 1,   m12: 0,   m13: 0,   m14: 0,
            m21: 0,   m22: 1,   m23: 0,   m24: 0,
            m31: 0,   m32: 0,   m33: 1,   m34: 0,
            m41: t.x, m42: t.y, m43: t.z, m44: 1
        )
    }

    public static func rotated(by axisAngle: Vector4) -> Matrix4 {
        return Matrix4(quaternion: Quaternion(axisAngle: axisAngle))
    }

    public init(quaternion q: Quaternion) {
        self.init(
            m11: 1 - 2 * (q.y * q.y + q.z * q.z),
            m12: 2 * (q.x * q.y + q.z * q.w),
            m13: 2 * (q.x * q.z - q.y * q.w),
            m14: 0,

            m21: 2 * (q.x * q.y - q.z * q.w),
            m22: 1 - 2 * (q.x * q.x + q.z * q.z),
            m23: 2 * (q.y * q.z + q.x * q.w),
            m24: 0,

            m31: 2 * (q.x * q.z + q.y * q.w),
            m32: 2 * (q.y * q.z - q.x * q.w),
            m33: 1 - 2 * (q.x * q.x + q.y * q.y), m34: 0,
            m41: 0, m42: 0, m43: 0, m44: 1
        )
    }

    public init(fovx: Scalar, fovy: Scalar, near: Scalar, far: Scalar) {
        self.init(fovy: fovy, aspect: fovx / fovy, near: near, far: far)
    }

    public init(fovx: Scalar, aspect: Scalar, near: Scalar, far: Scalar) {
        self.init(fovy: fovx / aspect, aspect: aspect, near: near, far: far)
    }

    public init(fovy: Scalar, aspect: Scalar, near: Scalar, far: Scalar) {
        let dz = far - near

        precondition(dz > 0, "Far value must be greater than near")
        precondition(fovy > 0, "Field of view must be nonzero and positive")
        precondition(aspect > 0, "Aspect ratio must be nonzero and positive")

        let r = fovy / 2
        let cotangent = cos(r) / sin(r)

        self.init(
            m11: cotangent / aspect, m12: 0,         m13: 0,                    m14: 0,
            m21: 0,                  m22: cotangent, m23: 0,                    m24: 0,
            m31: 0,                  m32: 0,         m33: -(far + near) / dz,   m34: -1,
            m41: 0,                  m42: 0,         m43: -2 * near * far / dz, m44: 0
        )
    }

    public init(top: Scalar, right: Scalar, bottom: Scalar, left: Scalar) {
        let dx = right - left
        let dy = top - bottom

        self.init(
            m11: 2 / dx,               m12: 0,                    m13:  0,            m14: 0,
            m21: 0,                    m22: 2 / dy,               m23:  0,            m24: 0,
            m31: 0,                    m32: 0,                    m33: -1,            m34: 0,
            m41: -(right + left) / dx, m42: -(top + bottom) / dy, m43:  0,            m44: 1
        )
    }

    public init(top: Scalar, right: Scalar, bottom: Scalar, left: Scalar, near: Scalar, far: Scalar) {
        let dx = right - left
        let dy = top - bottom
        let dz = far - near

        self.init(
            m11: 2 / dx,               m12: 0,                    m13: 0,                  m14: 0,
            m21: 0,                    m22: 2 / dy,               m23: 0,                  m24: 0,
            m31: 0,                    m32: 0,                    m33: -2 / dz,            m34: 0,
            m41: -(right + left) / dx, m42: -(top + bottom) / dy, m43: -(far + near) / dz, m44: 1
        )
    }

    public init(lookAt eye: Vector3, center: Vector3, up: Vector3) {
        let f = (center - eye).normalized()
        let s = f.cross(up).normalized()
        let u = s.cross(f)

        self.init(
            m11: s.x,         m12: u.x,         m13: -f.x,       m14: 0,
            m21: s.y,         m22: u.y,         m23: -f.y,       m24: 0,
            m31: s.z,         m32: u.z,         m33: -f.z,       m34: 0,
            m41: -s.dot(eye), m42: -u.dot(eye), m43: f.dot(eye), m44: 1
        )
    }
}

extension Matrix4 {

    public var translation: Vector3 {
        return Vector3(x: m41, y: m42, z: m43)
    }

    public var rotation: Quaternion {
        return Quaternion.init(rotationMatrix: self)
    }
}

extension Matrix4 {

    public init(_ m: [Scalar]) {
        assert(m.count == 16, "Array must contain 16 elements, contained \(m.count)")
        m11 = m[0]
        m12 = m[1]
        m13 = m[2]
        m14 = m[3]
        m21 = m[4]
        m22 = m[5]
        m23 = m[6]
        m24 = m[7]
        m31 = m[8]
        m32 = m[9]
        m33 = m[10]
        m34 = m[11]
        m41 = m[12]
        m42 = m[13]
        m43 = m[14]
        m44 = m[15]
    }
}

extension Array where Element == Scalar {

    init(_ m: Matrix4) {
        self = [m.m11, m.m12, m.m13, m.m14, m.m21, m.m22, m.m23, m.m24, m.m31, m.m32, m.m33, m.m34, m.m41, m.m42, m.m43, m.m44]
    }
}

extension Matrix4 {

    public var adjugate: Matrix4 {
        var m = Matrix4.identity

        m.m11 = m22 * m33 * m44 - m22 * m34 * m43
        m.m11 += -m32 * m23 * m44 + m32 * m24 * m43
        m.m11 += m42 * m23 * m34 - m42 * m24 * m33

        m.m21 = -m21 * m33 * m44 + m21 * m34 * m43
        m.m21 += m31 * m23 * m44 - m31 * m24 * m43
        m.m21 += -m41 * m23 * m34 + m41 * m24 * m33

        m.m31 = m21 * m32 * m44 - m21 * m34 * m42
        m.m31 += -m31 * m22 * m44 + m31 * m24 * m42
        m.m31 += m41 * m22 * m34 - m41 * m24 * m32

        m.m41 = -m21 * m32 * m43 + m21 * m33 * m42
        m.m41 += m31 * m22 * m43 - m31 * m23 * m42
        m.m41 += -m41 * m22 * m33 + m41 * m23 * m32

        m.m12 = -m12 * m33 * m44 + m12 * m34 * m43
        m.m12 += m32 * m13 * m44 - m32 * m14 * m43
        m.m12 += -m42 * m13 * m34 + m42 * m14 * m33

        m.m22 = m11 * m33 * m44 - m11 * m34 * m43
        m.m22 += -m31 * m13 * m44 + m31 * m14 * m43
        m.m22 += m41 * m13 * m34 - m41 * m14 * m33

        m.m32 = -m11 * m32 * m44 + m11 * m34 * m42
        m.m32 += m31 * m12 * m44 - m31 * m14 * m42
        m.m32 += -m41 * m12 * m34 + m41 * m14 * m32

        m.m42 = m11 * m32 * m43 - m11 * m33 * m42
        m.m42 += -m31 * m12 * m43 + m31 * m13 * m42
        m.m42 += m41 * m12 * m33 - m41 * m13 * m32

        m.m13 = m12 * m23 * m44 - m12 * m24 * m43
        m.m13 += -m22 * m13 * m44 + m22 * m14 * m43
        m.m13 += m42 * m13 * m24 - m42 * m14 * m23

        m.m23 = -m11 * m23 * m44 + m11 * m24 * m43
        m.m23 += m21 * m13 * m44 - m21 * m14 * m43
        m.m23 += -m41 * m13 * m24 + m41 * m14 * m23

        m.m33 = m11 * m22 * m44 - m11 * m24 * m42
        m.m33 += -m21 * m12 * m44 + m21 * m14 * m42
        m.m33 += m41 * m12 * m24 - m41 * m14 * m22

        m.m43 = -m11 * m22 * m43 + m11 * m23 * m42
        m.m43 += m21 * m12 * m43 - m21 * m13 * m42
        m.m43 += -m41 * m12 * m23 + m41 * m13 * m22

        m.m14 = -m12 * m23 * m34 + m12 * m24 * m33
        m.m14 += m22 * m13 * m34 - m22 * m14 * m33
        m.m14 += -m32 * m13 * m24 + m32 * m14 * m23

        m.m24 = m11 * m23 * m34 - m11 * m24 * m33
        m.m24 += -m21 * m13 * m34 + m21 * m14 * m33
        m.m24 += m31 * m13 * m24 - m31 * m14 * m23

        m.m34 = -m11 * m22 * m34 + m11 * m24 * m32
        m.m34 += m21 * m12 * m34 - m21 * m14 * m32
        m.m34 += -m31 * m12 * m24 + m31 * m14 * m22

        m.m44 = m11 * m22 * m33 - m11 * m23 * m32
        m.m44 += -m21 * m12 * m33 + m21 * m13 * m32
        m.m44 += m31 * m12 * m23 - m31 * m13 * m22

        return m
    }

    private func determinant(forAdjugate m: Matrix4) -> Scalar {
        return m11 * m.m11 + m12 * m.m21 + m13 * m.m31 + m14 * m.m41
    }

    public var determinant: Scalar {
        return determinant(forAdjugate: adjugate)
    }

    public var transposed: Matrix4 {
        return Matrix4(
            m11: m11, m12: m21, m13: m31, m14: m41,
            m21: m12, m22: m22, m23: m32, m24: m42,
            m31: m13, m32: m23, m33: m33, m34: m43,
            m41: m14, m42: m24, m43: m34, m44: m44
        )
    }

    public var inversed: Matrix4 {
        let adjugate = self.adjugate // Avoid recalculation
        return adjugate * (1 / determinant(forAdjugate: adjugate))
    }

    public func translated(by v: Vector3) -> Matrix4 {
        var m = self
        m.m41 += v.x
        m.m42 += v.y
        m.m43 += v.z
        return m
    }

    /// Map the specified location into window coordinates (World -> Screen)
    public static func project(location loc: Vector3, modelview model: Matrix4, projection proj: Matrix4, viewport: Vector4) -> Vector3? {
        var tmp = Vector4(loc, w: 1)
        tmp = model * tmp
        tmp = proj * tmp

        tmp /= tmp.w
        tmp.x = tmp.x * 0.5 + 0.5
        tmp.y = tmp.y * 0.5 + 0.5
        tmp.z = tmp.z * 0.5 + 0.5

        tmp.x = tmp.x * viewport.z + viewport.x
        tmp.y = tmp.y * viewport.w + viewport.y

        return tmp.xyz
    }

    /// Map the specified window location into object location (Screen -> World)
    public static func unproject(win: Vector3, modelview model: Matrix4, projection proj: Matrix4, viewport: Vector4) -> Vector3? {
        let inversed = (proj * model).inversed

        var tmp = Vector4(win, w: 1)
        tmp.x = (tmp.x - viewport.x) / viewport.z
        tmp.y = (tmp.y - viewport.y) / viewport.w

        tmp.x = tmp.x * 2 - 1
        tmp.y = tmp.y * 2 - 1
        tmp.z = tmp.z * 2 - 1
        //tmp.w = tmp.w * 2 - 1

        var obj = inversed * tmp
        obj /= obj.w

        return  obj.xyz
    }
}

extension Matrix4 {
    
    public static prefix func -(m: Matrix4) -> Matrix4 {
        return m.inversed
    }

    public static func *(lhs: Matrix4, rhs: Matrix4) -> Matrix4 {
        var m = Matrix4.identity

        m.m11 = lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12
        m.m11 += lhs.m31 * rhs.m13 + lhs.m41 * rhs.m14

        m.m12 = lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12
        m.m12 += lhs.m32 * rhs.m13 + lhs.m42 * rhs.m14

        m.m13 = lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12
        m.m13 += lhs.m33 * rhs.m13 + lhs.m43 * rhs.m14

        m.m14 = lhs.m14 * rhs.m11 + lhs.m24 * rhs.m12
        m.m14 += lhs.m34 * rhs.m13 + lhs.m44 * rhs.m14

        m.m21 = lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22
        m.m21 += lhs.m31 * rhs.m23 + lhs.m41 * rhs.m24

        m.m22 = lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22
        m.m22 += lhs.m32 * rhs.m23 + lhs.m42 * rhs.m24

        m.m23 = lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22
        m.m23 += lhs.m33 * rhs.m23 + lhs.m43 * rhs.m24

        m.m24 = lhs.m14 * rhs.m21 + lhs.m24 * rhs.m22
        m.m24 += lhs.m34 * rhs.m23 + lhs.m44 * rhs.m24

        m.m31 = lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32
        m.m31 += lhs.m31 * rhs.m33 + lhs.m41 * rhs.m34

        m.m32 = lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32
        m.m32 += lhs.m32 * rhs.m33 + lhs.m42 * rhs.m34

        m.m33 = lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32
        m.m33 += lhs.m33 * rhs.m33 + lhs.m43 * rhs.m34

        m.m34 = lhs.m14 * rhs.m31 + lhs.m24 * rhs.m32
        m.m34 += lhs.m34 * rhs.m33 + lhs.m44 * rhs.m34

        m.m41 = lhs.m11 * rhs.m41 + lhs.m21 * rhs.m42
        m.m41 += lhs.m31 * rhs.m43 + lhs.m41 * rhs.m44

        m.m42 = lhs.m12 * rhs.m41 + lhs.m22 * rhs.m42
        m.m42 += lhs.m32 * rhs.m43 + lhs.m42 * rhs.m44

        m.m43 = lhs.m13 * rhs.m41 + lhs.m23 * rhs.m42
        m.m43 += lhs.m33 * rhs.m43 + lhs.m43 * rhs.m44

        m.m44 = lhs.m14 * rhs.m41 + lhs.m24 * rhs.m42
        m.m44 += lhs.m34 * rhs.m43 + lhs.m44 * rhs.m44

        return m
    }

    public static func *(lhs: Matrix4, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }

    public static func *(lhs: Matrix4, rhs: Vector4) -> Vector4 {
        return rhs * lhs
    }

    public static func *(lhs: Matrix4, rhs: Scalar) -> Matrix4 {
        return Matrix4(
            m11: lhs.m11 * rhs, m12: lhs.m12 * rhs, m13: lhs.m13 * rhs, m14: lhs.m14 * rhs,
            m21: lhs.m21 * rhs, m22: lhs.m22 * rhs, m23: lhs.m23 * rhs, m24: lhs.m24 * rhs,
            m31: lhs.m31 * rhs, m32: lhs.m32 * rhs, m33: lhs.m33 * rhs, m34: lhs.m34 * rhs,
            m41: lhs.m41 * rhs, m42: lhs.m42 * rhs, m43: lhs.m43 * rhs, m44: lhs.m44 * rhs
        )
    }

    public static func ==(lhs: Matrix4, rhs: Matrix4) -> Bool {
        if lhs.m11 != rhs.m11 { return false }
        if lhs.m12 != rhs.m12 { return false }
        if lhs.m13 != rhs.m13 { return false }
        if lhs.m14 != rhs.m14 { return false }
        if lhs.m21 != rhs.m21 { return false }
        if lhs.m22 != rhs.m22 { return false }
        if lhs.m23 != rhs.m23 { return false }
        if lhs.m24 != rhs.m24 { return false }
        if lhs.m31 != rhs.m31 { return false }
        if lhs.m32 != rhs.m32 { return false }
        if lhs.m33 != rhs.m33 { return false }
        if lhs.m34 != rhs.m34 { return false }
        if lhs.m41 != rhs.m41 { return false }
        if lhs.m42 != rhs.m42 { return false }
        if lhs.m43 != rhs.m43 { return false }
        if lhs.m44 != rhs.m44 { return false }
        return true
    }

    public static func ~=(lhs: Matrix4, rhs: Matrix4) -> Bool {
        if !(lhs.m11 ~= rhs.m11) { return false }
        if !(lhs.m12 ~= rhs.m12) { return false }
        if !(lhs.m13 ~= rhs.m13) { return false }
        if !(lhs.m14 ~= rhs.m14) { return false }
        if !(lhs.m21 ~= rhs.m21) { return false }
        if !(lhs.m22 ~= rhs.m22) { return false }
        if !(lhs.m23 ~= rhs.m23) { return false }
        if !(lhs.m24 ~= rhs.m24) { return false }
        if !(lhs.m31 ~= rhs.m31) { return false }
        if !(lhs.m32 ~= rhs.m32) { return false }
        if !(lhs.m33 ~= rhs.m33) { return false }
        if !(lhs.m34 ~= rhs.m34) { return false }
        if !(lhs.m41 ~= rhs.m41) { return false }
        if !(lhs.m42 ~= rhs.m42) { return false }
        if !(lhs.m43 ~= rhs.m43) { return false }
        if !(lhs.m44 ~= rhs.m44) { return false }
        return true
    }
}

extension Matrix4: CustomStringConvertible {

    public var description: String {
        return String(format: "%.1f, %.1f, %.1f, %.1f,\n%.1f, %.1f, %.1f, %.1f,\n%.1f, %.1f, %.1f, %.1f,\n%.1f, %.1f, %.1f, %.1f", m11, m12, m13, m14,m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44)
    }
}
