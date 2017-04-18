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

public struct Vector3 {

    public var x: Scalar
    public var y: Scalar
    public var z: Scalar

    public init(x: Scalar, y: Scalar, z: Scalar) {
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Vector3: Equatable, Hashable {

    public static let zero = Vector3(x: 0, y: 0, z: 0)
    public static let x = Vector3(x: 1, y: 0, z: 0)
    public static let y = Vector3(x: 0, y: 1, z: 0)
    public static let z = Vector3(x: 0, y: 0, z: 1)

    public var hashValue: Int {
        return x.hashValue &+ y.hashValue &+ z.hashValue
    }

    public var lengthSquared: Scalar {
        return x * x + y * y + z * z
    }

    public var length: Scalar {
        return sqrt(lengthSquared)
    }

    public var inversed: Vector3 {
        return -self
    }

    public var xy: Vector2 {
        get {
            return Vector2(x: x, y: y)
        }
        set (v) {
            x = v.x
            y = v.y
        }
    }

    public var xz: Vector2 {
        get {
            return Vector2(x: x, y: z)
        }
        set (v) {
            x = v.x
            z = v.y
        }
    }

    public var yz: Vector2 {
        get {
            return Vector2(x: y, y: z)
        }
        set (v) {
            y = v.x
            z = v.y
        }
    }

    public var xyz: Vector3 {
        get {
            return Vector3(x: y, y: y, z: z)
        }
        set (v) {
            y = v.x
            y = v.y
            z = v.z
        }
    }
}

extension Vector3 {

    public init(_ v: [Scalar]) {
        precondition(v.count == 3, "Array must contain 3 elements")
        self.init(x: v[0], y: v[1], z: v[2])
    }

    public init(_ v: Vector2, z: Scalar) {
        self.init(x: v.x, y: v.y, z: z)
    }

    public init(_ v: Vector3) {
        self.init(x: v.x, y: v.y, z: v.z)
    }

    public init(_ v: Vector4) {
        if v.w ~= 0 {
            self.init(v.xyz)
        } else {
            self.init(v.xyz / v.w)
        }
    }
}

extension Array where Element == Scalar {

    init(_ v: Vector3) {
        self = [v.x, v.y, v.z]
    }
}

extension Vector3 {

    public func dot(_ v: Vector3) -> Scalar {
        return x * v.x + y * v.y + z * v.z
    }

    public func cross(_ v: Vector3) -> Vector3 {
        return Vector3(x: y * v.z - z * v.y, y: z * v.x - x * v.z, z: x * v.y - y * v.x)
    }

    public func normalized() -> Vector3 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    public func interpolated(with v: Vector3, by t: Scalar) -> Vector3 {
        return self + (v - self) * t
    }

    public func angle(with rhs: Vector3) -> Scalar {
        if self == rhs {
            return 0
        }
        let dot = self.dot(rhs)
        let theta = acos(dot / (self.length * rhs.length))
        return theta
    }

    public func isEqual(v2 rhs: Vector3, epsilon: Scalar) -> Bool {
        return fabs(x - rhs.x) < epsilon && fabs(y - rhs.y) < epsilon
    }
}

extension Vector3 {

    public static prefix func -(v: Vector3) -> Vector3 {
        return Vector3(x: -v.x, y: -v.y, z: -v.z)
    }

    public static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    public static func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    public static func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }

    public static func *(lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    public static func *(lhs: Vector3, rhs: Matrix3) -> Vector3 {
        return Vector3(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32,
            z: lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33
        )
    }

    public static func *(lhs: Vector3, rhs: Matrix4) -> Vector3 {
        return Vector3(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31 + rhs.m41,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32 + rhs.m42,
            z: lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33 + rhs.m43
        )
    }

    public static func *(v: Vector3, q: Quaternion) -> Vector3 {
        let qv = q.xyz
        let uv = qv.cross(v)
        let uuv = qv.cross(uv)
        return v + (uv * 2 * q.w) + (uuv * 2)
    }

    public static func /(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
    }

    public static func /(lhs: Vector3, rhs: Scalar) -> Vector3 {
        return Vector3(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    public static func ==(lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }

    public static func ~=(lhs: Vector3, rhs: Vector3) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z
    }
}

extension Vector3 {

    public static func +=(lhs: inout Vector3, rhs: Vector3) {
        lhs = lhs + rhs
    }

    public static func -=(lhs: inout Vector3, rhs: Vector3) {
        lhs = lhs - rhs
    }
}
