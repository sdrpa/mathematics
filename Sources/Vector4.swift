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

public struct Vector4 {

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

extension Vector4: Equatable, Hashable {
    
    public static let zero = Vector4(x: 0, y: 0, z: 0, w: 0)
    public static let x = Vector4(x: 1, y: 0, z: 0, w: 0)
    public static let y = Vector4(x: 0, y: 1, z: 0, w: 0)
    public static let z = Vector4(x: 0, y: 0, z: 1, w: 0)
    public static let w = Vector4(x: 0, y: 0, z: 0, w: 1)

    public var hashValue: Int {
        return x.hashValue &+ y.hashValue &+ z.hashValue &+ w.hashValue
    }

    public var lengthSquared: Scalar {
        return x * x + y * y + z * z + w * w
    }

    public var length: Scalar {
        return sqrt(lengthSquared)
    }

    public var inversed: Vector4 {
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
}

extension Vector4 {

    public init(_ v: [Scalar]) {
        precondition(v.count == 4, "Array must contain 4 elements")
        self.init(x: v[0], y: v[1], z: v[2], w: v[3])
    }

    public init(_ v: Vector3, w: Scalar) {
        self.init(x: v.x, y: v.y, z: v.z, w: w)
    }

    public func toVector3() -> Vector3 {
        if w ~= 0 {
            return xyz
        } else {
            return xyz / w
        }
    }
}

extension Array where Element == Scalar {

    init(_ v: Vector4) {
        self = [v.x, v.y, v.z, v.w]
    }
}

extension Vector4 {

    public func dot(_ v: Vector4) -> Scalar {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }

    public func normalized() -> Vector4 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    public func interpolated(with v: Vector4, by t: Scalar) -> Vector4 {
        return self + (v - self) * t
    }
}

extension Vector4 {

    public static prefix func -(v: Vector4) -> Vector4 {
        return Vector4(x: -v.x, y: -v.y, z: -v.z, w: -v.w)
    }

    public static func +(lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
    }

    public static func -(lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z, w: lhs.w - rhs.w)
    }

    public static func *(lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z, w: lhs.w * rhs.w)
    }

    public static func *(lhs: Vector4, rhs: Scalar) -> Vector4 {
        return Vector4(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs)
    }

    public static func *(lhs: Vector4, rhs: Matrix4) -> Vector4 {
        return Vector4(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + lhs.z * rhs.m31 + lhs.w * rhs.m41,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + lhs.z * rhs.m32 + lhs.w * rhs.m42,
            z: lhs.x * rhs.m13 + lhs.y * rhs.m23 + lhs.z * rhs.m33 + lhs.w * rhs.m43,
            w: lhs.x * rhs.m14 + lhs.y * rhs.m24 + lhs.z * rhs.m34 + lhs.w * rhs.m44
        )
    }

    public static func /(lhs: Vector4, rhs: Vector4) -> Vector4 {
        return Vector4(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z, w: lhs.w / rhs.w)
    }

    public static func /(lhs: Vector4, rhs: Scalar) -> Vector4 {
        return Vector4(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs)
    }

    public static func ==(lhs: Vector4, rhs: Vector4) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }

    public static func ~=(lhs: Vector4, rhs: Vector4) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}

extension Vector4 {

    public static func /=(lhs: inout Vector4, rhs: Scalar) {
        lhs = lhs / rhs
    }
}
