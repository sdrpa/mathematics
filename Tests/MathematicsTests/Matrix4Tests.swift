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

import XCTest
@testable import Mathematics

class Matrix4Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTranslateByVector() {
        let m = Matrix4(
            m11: 1, m12: 0 ,m13: 0 ,m14: 0,
            m21: 0, m22: 1, m23: 0, m24: 0,
            m31: 0, m32: 0, m33: 1, m34: 0,
            m41: 5, m42: 5, m43: 5, m44: 1)
        let m1 = m.translated(by: Vector3(x: 2, y: 3, z: 4))

        let expected = Matrix4(
            m11: 1, m12: 0 ,m13: 0 ,m14: 0,
            m21: 0, m22: 1, m23: 0, m24: 0,
            m31: 0, m32: 0, m33: 1, m34: 0,
            m41: 7, m42: 8, m43: 9, m44: 1)
        XCTAssertEqual(expected, m1)
    }

    func testProject() {
        let width = Scalar(600.0)
        let height = Scalar(600.0)

        let view = Matrix4.translated(by: Vector3(x: 0.0, y: 0.0, z: -3.0))
        let proj = Matrix4(fovx: 45, aspect: 600/600, near: 0.1, far: 10)
        let location = Matrix4.project(location: Vector3(x: 0, y: 0, z: 0.0),
                                       modelview: view,
                                       projection: proj,
                                       viewport: Vector4(x: 0, y: 0, z: width, w: height))
        guard let result = location else { return XCTFail() }
        XCTAssertTrue(Vector3(x: 300.0, y: 300.0, z: 0.976431012) ~= result)
    }

    func testUnproject() {
        let width = Scalar(600.0)
        let height = Scalar(600.0)

        let view = Matrix4.translated(by: Vector3(x: 0.0, y: 0.0, z: -3.0))
        let proj = Matrix4(fovx: 45, aspect: 600/600, near: 0.1, far: 10)
        let location = Matrix4.unproject(win: Vector3(x: 300, y: 300, z: 0.0),
                                         modelview: view,
                                         projection: proj,
                                         viewport: Vector4(x: 0, y: 0, z: width, w: height))
        guard let result = location else { return XCTFail() }
        XCTAssertTrue(Vector3(x: 0.0, y: 0.0, z: 2.89999986) ~= result)
    }

    func testMatrix4MultiplicationPerformance() {
        let a = Matrix4.rotated(by: Vector4(x: 1, y: 0, z: 0, w: Double.pi/2))
        var b = Matrix4.translated(by: Vector3(x: 1, y: 10, z: 24))
        measure {
            for _ in 0 ..< 100000 {
                b = a * b
            }
        }
    }
}
