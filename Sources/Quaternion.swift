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

public struct Quaternion {

    public var x: Scalar
    public var y: Scalar
    public var z: Scalar
    public var w: Scalar

    public init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}

extension Quaternion: Equatable, Hashable {
    
    public static let zero = Quaternion(x: 0, y: 0, z: 0, w: 0)
    public static let identity = Quaternion(x: 0, y: 0, z: 0, w: 1)

    public var hashValue: Int {
        return x.hashValue &+ y.hashValue &+ z.hashValue &+ w.hashValue
    }

    public var lengthSquared: Scalar {
        return x * x + y * y + z * z + w * w
    }

    public var length: Scalar {
        return sqrt(lengthSquared)
    }

    public var inversed: Quaternion {
        return -self
    }

    public var xyz: Vector3 {
        get {
            return Vector3(x: x, y: y, z: z)
        }
        set (v) {
            x = v.x
            y = v.y
            z = v.z
        }
    }

    public var pitch: Scalar {
        return atan2(2 * (y * z + w * x), w * w - x * x - y * y + z * z)
    }

    public var yaw: Scalar {
        return asin(-2 * (x * z - w * y))
    }

    public var roll: Scalar {
        return atan2(2 * (x * y + w * z), w * w + x * x - y * y - z * z)
    }

    public var matrix: Matrix4 {
        let q = self
        let qxx = q.x * q.x
        let qyy = q.y * q.y
        let qzz = q.z * q.z
        let qxz = q.x * q.z
        let qxy = q.x * q.y
        let qyz = q.y * q.z
        let qwx = q.w * q.x
        let qwy = q.w * q.y
        let qwz = q.w * q.z

        let m = Matrix4(m11: 1 - 2 * (qyy +  qzz), m12: 2 * (qxy + qwz),       m13: 2 * (qxz - qwy),      m14: 0,
                        m21: 2 * (qxy - qwz),      m22: 1 - 2 * (qxx +  qzz),  m23: 2 * (qyz + qwx),      m24: 0,
                        m31: 2 * (qxz + qwy),      m32: 2 * (qyz - qwx),       m33: 1 - 2 * (qxx +  qyy), m34: 0,
                        m41: 0,                    m42: 0,                     m43: 0,                    m44: 1)
        return m
    }
}

extension Quaternion {

    public init(axisAngle: Vector4) {
        let r = axisAngle.w * 0.5
        let scale = sin(r)
        let a = axisAngle.xyz * scale
        self.init(x: a.x, y: a.y, z: a.z, w: cos(r))
    }

    public init(pitch: Scalar, yaw: Scalar, roll: Scalar) {
        let quatPitch = Quaternion(axisAngle: Vector4(x: 1, y: 0, z: 0, w: pitch))
        let quatYaw = Quaternion(axisAngle: Vector4(x: 0, y: 1, z: 0, w: yaw))
        let quatRoll = Quaternion(axisAngle: Vector4(x: 0, y: 0, z: 1, w: roll))
        self = quatPitch * quatYaw * quatRoll
    }

    public init(rotationMatrix m: Matrix4) {
        let diagonal = m.m11 + m.m22 + m.m33 + 1
        if diagonal ~= 0 {
            let scale = sqrt(diagonal) * 2
            self.init(
                x: (m.m32 - m.m23) / scale,
                y: (m.m13 - m.m31) / scale,
                z: (m.m21 - m.m12) / scale,
                w: 0.25 * scale
            )
        } else if m.m11 > max(m.m22, m.m33) {
            let scale = sqrt(1 + m.m11 - m.m22 - m.m33) * 2
            self.init(
                x: 0.25 * scale,
                y: (m.m21 + m.m12) / scale,
                z: (m.m13 + m.m31) / scale,
                w: (m.m32 - m.m23) / scale
            )
        } else if m.m22 > m.m33 {
            let scale = sqrt(1 + m.m22 - m.m11 - m.m33) * 2
            self.init(
                x: (m.m21 + m.m12) / scale,
                y: 0.25 * scale,
                z: (m.m32 + m.m23) / scale,
                w: (m.m13 - m.m31) / scale
            )
        } else {
            let scale = sqrt(1 + m.m33 - m.m11 - m.m22) * 2
            self.init(
                x: (m.m13 + m.m31) / scale,
                y: (m.m32 + m.m23) / scale,
                z: 0.25 * scale,
                w: (m.m21 - m.m12) / scale
            )
        }
    }

    public init(axis v: Vector3, angle: Scalar) {
        let s = sin(angle * 0.5)

        self.x = v.x * s
        self.y = v.y * s
        self.z = v.z * s
        self.w = cos(angle * 0.5)
    }
}

extension Quaternion {

    public init(_ v: [Scalar]) {
        precondition(v.count == 4, "Array must contain 4 elements")
        x = v[0]
        y = v[1]
        z = v[2]
        w = v[3]
    }

    public init(_ q: Quaternion) {
        self.init(x: q.x, y: q.y, z: q.z, w: q.w)
    }
}

extension Array where Element == Scalar {

    init(_ q: Quaternion) {
        self = [q.x, q.y, q.z, q.w]
    }
}

extension Quaternion {

    public func toAxisAngle() -> Vector4 {
        let scale = xyz.length
        if scale ~= 0 || scale ~= (.PI * 2) {
            return .z
        } else {
            return Vector4(x: x / scale, y: y / scale, z: z / scale, w: acos(w) * 2)
        }
    }

    public func toPitchYawRoll() -> (pitch: Scalar, yaw: Scalar, roll: Scalar) {
        return (pitch, yaw, roll)
    }
}

extension Quaternion {

    public func dot(_ v: Quaternion) -> Scalar {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }

    public func normalized() -> Quaternion {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    public func conjugate() -> Quaternion {
        return Quaternion(x: -self.x, y: -self.y, z: -self.z, w: w)
    }

    public func interpolated(with q: Quaternion, by t: Scalar) -> Quaternion {
        let dot = max(-1, min(1, self.dot(q)))
        if dot ~= 1 {
            return (self + (q - self) * t).normalized()
        }

        let theta = acos(dot) * t
        let t1 = self * cos(theta)
        let t2 = (q - (self * dot)).normalized() * sin(theta)
        return t1 + t2
    }

    /// https://bitbucket.org/sinbad/ogre/src/9db75e3ba05c/OgreMain/include/OgreVector3.h?fileviewer=file-view-default#cl-651
    public static func rotation(v1: Vector3, v2: Vector3, fallbackAxis: Vector3 = .zero) -> Quaternion {
        var q = Quaternion.identity
        let vec1 = v1.normalized()
        let vec2 = v2.normalized()

        let d = vec1.dot(vec2)
        if d >= 1.0 { // If dot == 1, vectors are the same
            return Quaternion.identity
        }
        if d < (1e-6 - 1.0) {
            if fallbackAxis != .zero {
                // Rotate 180 degrees about the fallback axis
                q = Quaternion.init(axis: fallbackAxis, angle: Scalar.PI)
            } else {
                // Generate an axis
                var axis = Vector3(x: 1, y: 0, z: 0).cross(v1)
                if axis.length == 0 { // Pick another if colinear
                    axis = Vector3(x: 0, y: 1, z: 0).cross(v1)
                }
                q = Quaternion.init(axis: axis.normalized(), angle: Scalar.PI)
            }
        } else {
            let s = sqrt((1+d)*2)
            let inv = 1/s

            let c = vec1.cross(vec2)

            q = Quaternion(x: c.x * inv,
                       y: c.y * inv,
                       z: c.z * inv,
                       w: s * 0.5)
                .normalized()
        }
        return q;
    }
}

extension Quaternion {

    public static prefix func -(q: Quaternion) -> Quaternion {
        return Quaternion(x: -q.x, y: -q.y, z: -q.z, w: q.w)
    }

    public static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }

    public static func -(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }

    public static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            x: lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            y: lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
            z: lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
            w: lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }

    public static func *(lhs: Quaternion, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }

    public static func *(lhs: Quaternion, rhs: Scalar) -> Quaternion {
        return Quaternion(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
    }

    public static func /(lhs: Quaternion, rhs: Scalar) -> Quaternion {
        return Quaternion(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs)
    }

    public static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }

    public static func ~=(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}

extension Quaternion {

    public static func *=(lhs: inout Quaternion, rhs: Quaternion) {
        lhs = lhs * rhs
    }
}

extension Quaternion {

    public func equal(_ rhs: Quaternion, precision: Scalar) -> Bool {
        let x = self.x.equal(rhs.x, precision: precision)
        let y = self.y.equal(rhs.y, precision: precision)
        let z = self.z.equal(rhs.z, precision: precision)
        let w = self.w.equal(rhs.w, precision: precision)

        return x && y && z && w
    }
}
