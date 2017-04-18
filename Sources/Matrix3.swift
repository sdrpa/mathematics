
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

public struct Matrix3 {

    public var m11: Scalar
    public var m12: Scalar
    public var m13: Scalar
    public var m21: Scalar
    public var m22: Scalar
    public var m23: Scalar
    public var m31: Scalar
    public var m32: Scalar
    public var m33: Scalar

    public init(m11: Scalar, m12: Scalar, m13: Scalar,
                m21: Scalar, m22: Scalar, m23: Scalar,
                m31: Scalar, m32: Scalar, m33: Scalar) {
        self.m11 = m11 // 0
        self.m12 = m12 // 1
        self.m13 = m13 // 2
        self.m21 = m21 // 3
        self.m22 = m22 // 4
        self.m23 = m23 // 5
        self.m31 = m31 // 6
        self.m32 = m32 // 7
        self.m33 = m33 // 8
    }
}

extension Matrix3: Equatable, Hashable {
    
    public static let identity = Matrix3(m11: 1, m12: 0 ,m13: 0 ,m21: 0, m22: 1, m23: 0, m31: 0, m32: 0, m33: 1)

    public var hashValue: Int {
        var hash = m11.hashValue &+ m12.hashValue &+ m13.hashValue
        hash = hash &+ m21.hashValue &+ m22.hashValue &+ m23.hashValue
        hash = hash &+ m31.hashValue &+ m32.hashValue &+ m33.hashValue
        return hash
    }

    public static func scaled(by s: Vector2) -> Matrix3 {
        return Matrix3(
            m11: s.x, m12: 0,   m13: 0,
            m21: 0,   m22: s.y, m23: 0,
            m31: 0,   m32: 0,   m33: 1
        )
    }

    public static func translated(by t: Vector2) -> Matrix3 {
        return Matrix3(
            m11: 1,   m12: 0,   m13: 0,
            m21: 0,   m22: 1,   m23: 0,
            m31: t.x, m32: t.y, m33: 1
        )
    }

    public static func rotated(by radians: Scalar) -> Matrix3 {
        let cs = cos(radians)
        let sn = sin(radians)
        return Matrix3(
            m11: cs,  m12: sn, m13: 0,
            m21: -sn, m22: cs, m23: 0,
            m31: 0,   m32: 0,  m33: 1
        )
    }
}

extension Matrix3 {

    public init(_ m: [Scalar]) {
        assert(m.count == 9, "Array must contain 9 elements, contained \(m.count)")
        self.init(m11: m[0], m12: m[1], m13: m[2], m21: m[3], m22: m[4], m23: m[5], m31: m[6], m32: m[7], m33: m[8])
    }
}

extension Array where Element == Scalar {

    init(_ m: Matrix3) {
        self =  [m.m11, m.m12, m.m13, m.m21, m.m22, m.m23, m.m31, m.m32, m.m33]
    }
}

extension Matrix3 {

    public var adjugate: Matrix3 {
        return Matrix3(
            m11: m22 * m33 - m23 * m32,
            m12: m13 * m32 - m12 * m33,
            m13: m12 * m23 - m13 * m22,
            m21: m23 * m31 - m21 * m33,
            m22: m11 * m33 - m13 * m31,
            m23: m13 * m21 - m11 * m23,
            m31: m21 * m32 - m22 * m31,
            m32: m12 * m31 - m11 * m32,
            m33: m11 * m22 - m12 * m21
        )
    }

    public var determinant: Scalar {
        return (m11 * m22 * m33 + m12 * m23 * m31 + m13 * m21 * m32)
            - (m13 * m22 * m31 + m11 * m23 * m32 + m12 * m21 * m33)
    }

    public var transposed: Matrix3 {
        return Matrix3(m11: m11, m12: m21, m13: m31, m21: m12, m22: m22, m23: m32, m31: m13, m32: m23, m33: m33)
    }

    public var inversed: Matrix3 {
        return adjugate * (1 / determinant)
    }

    public func interpolated(with m: Matrix3, by t: Scalar) -> Matrix3 {
        return Matrix3(
            m11: m11 + (m.m11 - m11) * t,
            m12: m12 + (m.m12 - m12) * t,
            m13: m13 + (m.m13 - m13) * t,
            m21: m21 + (m.m21 - m21) * t,
            m22: m22 + (m.m22 - m22) * t,
            m23: m23 + (m.m23 - m23) * t,
            m31: m31 + (m.m31 - m31) * t,
            m32: m32 + (m.m32 - m32) * t,
            m33: m33 + (m.m33 - m33) * t
        )
    }
}

extension Matrix3 {

    public static prefix func -(m: Matrix3) -> Matrix3 {
        return m.inversed
    }

    public static func *(lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        return Matrix3(
            m11: lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12 + lhs.m31 * rhs.m13,
            m12: lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12 + lhs.m32 * rhs.m13,
            m13: lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12 + lhs.m33 * rhs.m13,
            m21: lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22 + lhs.m31 * rhs.m23,
            m22: lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22 + lhs.m32 * rhs.m23,
            m23: lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22 + lhs.m33 * rhs.m23,
            m31: lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32 + lhs.m31 * rhs.m33,
            m32: lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32 + lhs.m32 * rhs.m33,
            m33: lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32 + lhs.m33 * rhs.m33
        )
    }

    public static func *(lhs: Matrix3, rhs: Vector2) -> Vector2 {
        return rhs * lhs
    }

    public static func *(lhs: Matrix3, rhs: Vector3) -> Vector3 {
        return rhs * lhs
    }

    public static func *(lhs: Matrix3, rhs: Scalar) -> Matrix3 {
        return Matrix3(
            m11: lhs.m11 * rhs, m12: lhs.m12 * rhs, m13: lhs.m13 * rhs,
            m21: lhs.m21 * rhs, m22: lhs.m22 * rhs, m23: lhs.m23 * rhs,
            m31: lhs.m31 * rhs, m32: lhs.m32 * rhs, m33: lhs.m33 * rhs
        )
    }

    public static func ==(lhs: Matrix3, rhs: Matrix3) -> Bool {
        if lhs.m11 != rhs.m11 { return false }
        if lhs.m12 != rhs.m12 { return false }
        if lhs.m13 != rhs.m13 { return false }
        if lhs.m21 != rhs.m21 { return false }
        if lhs.m22 != rhs.m22 { return false }
        if lhs.m23 != rhs.m23 { return false }
        if lhs.m31 != rhs.m31 { return false }
        if lhs.m32 != rhs.m32 { return false }
        if lhs.m33 != rhs.m33 { return false }
        return true
    }

    public static func ~=(lhs: Matrix3, rhs: Matrix3) -> Bool {
        if !(lhs.m11 ~= rhs.m11) { return false }
        if !(lhs.m12 ~= rhs.m12) { return false }
        if !(lhs.m13 ~= rhs.m13) { return false }
        if !(lhs.m21 ~= rhs.m21) { return false }
        if !(lhs.m22 ~= rhs.m22) { return false }
        if !(lhs.m23 ~= rhs.m23) { return false }
        if !(lhs.m31 ~= rhs.m31) { return false }
        if !(lhs.m32 ~= rhs.m32) { return false }
        if !(lhs.m33 ~= rhs.m33) { return false }
        return true
    }
}
