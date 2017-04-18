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

public struct Vector2 {

    public var x: Scalar
    public var y: Scalar

    public init(x: Scalar, y: Scalar) {
        self.x = x
        self.y = y
    }
}

extension Vector2: Equatable, Hashable {

    public static let zero = Vector2(x: 0, y: 0)
    public static let x = Vector2(x: 1, y: 0)
    public static let y = Vector2(x: 0, y: 1)

    public var hashValue: Int {
        return x.hashValue &+ y.hashValue
    }

    public var lengthSquared: Scalar {
        return x * x + y * y
    }

    public var length: Scalar {
        return sqrt(lengthSquared)
    }

    public var inversed: Vector2 {
        return -self
    }
}

extension Vector2 {

    public init(_ v: [Scalar]) {
        precondition(v.count == 2, "Array must contain 2 elements")
        self.init(x: v[0], y: v[1])
    }
}

extension Array where Element == Scalar {

    init(_ v: Vector2) {
        self = [v.x, v.y]
    }
}

extension Vector2 {

    public func dot(_ v: Vector2) -> Scalar {
        return x * v.x + y * v.y
    }

    public func cross(_ v: Vector2) -> Scalar {
        return x * v.y - y * v.x
    }

    public func normalized() -> Vector2 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    public func rotated(by radians: Scalar) -> Vector2 {
        let cs = cos(radians)
        let sn = sin(radians)
        return Vector2(x: x * cs - y * sn, y: x * sn + y * cs)
    }

    public func rotated(by radians: Scalar, around pivot: Vector2) -> Vector2 {
        return (self - pivot).rotated(by: radians) + pivot
    }

    public func angle(with v: Vector2) -> Scalar {
        if self == v {
            return 0
        }

        let t1 = normalized()
        let t2 = v.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1, min(1, t1.dot(t2)))

        return atan2(cross, dot)
    }

    public func interpolated(with v: Vector2, by t: Scalar) -> Vector2 {
        return self + (v - self) * t
    }
}

extension Vector2 {

    public static prefix func -(v: Vector2) -> Vector2 {
        return Vector2(x: -v.x, y: -v.y)
    }

    public static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func *(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    public static func *(lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    public static func *(lhs: Vector2, rhs: Matrix3) -> Vector2 {
        return Vector2(
            x: lhs.x * rhs.m11 + lhs.y * rhs.m21 + rhs.m31,
            y: lhs.x * rhs.m12 + lhs.y * rhs.m22 + rhs.m32
        )
    }

    public static func /(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    public static func /(lhs: Vector2, rhs: Scalar) -> Vector2 {
        return Vector2(x: lhs.x / rhs, y: lhs.y / rhs)
    }

    public static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public static func ~=(lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y
    }
}
