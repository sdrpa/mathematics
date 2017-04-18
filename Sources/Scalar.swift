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

public typealias Scalar = Double

public extension Scalar {

    public static let PI = Scalar(Double.pi)
    public static let epsilon: Scalar = 0.0001

    public static func ~=(lhs: Scalar, rhs: Scalar) -> Bool {
        return Swift.abs(lhs - rhs) < .epsilon
    }

    public func equal(_ other: Scalar, precision p: Scalar) -> Bool {
        return abs(self - other) < (1 * p)
    }
}
