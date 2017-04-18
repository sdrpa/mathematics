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

import Measure
import XCTest
@testable import Mathematics

class QuaternionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRotationBetweenVectors() {

        let v1 = Vector3(x: 1.0, y: 0.0, z: 1.0)
        let v2 = Vector3(x: 0.5, y: 0.5, z: 1.0)

        let q1 = Quaternion.rotation(v1: v1, v2: v2); print(q1)
        XCTAssertTrue(Quaternion(x: -0.149429, y:-0.1494290, z: 0.149429, w: 0.965926).equal(q1, precision: 0.0001))
    }

    func testQuaternionToMatrix() {
        //Scalar(90).radians
        let q1 = Quaternion.init(axis: Vector3(x: 0, y: 1, z: 0), angle: Scalar(Radian(Degree(90))))
        let m = q1.matrix
        print(m)
        XCTAssertTrue(Matrix4(m11: 0, m12: 0, m13: -1, m14: 0,
                              m21: 0, m22: 1, m23:  0, m24: 0,
                              m31: 1, m32: 0, m33:  0, m34: 0,
                              m41: 0, m42: 0, m43:  0, m44: 1)
            ~= m)
    }
}
