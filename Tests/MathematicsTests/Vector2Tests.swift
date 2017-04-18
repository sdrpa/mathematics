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

class Vector2Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testArrayFromVector2() {
        let v = Vector2(x: 2, y: 3)
        let a = Array(v)
        XCTAssertEqual([2, 3], a)
    }

    func testAngleBetweenVectors() {
        let a = Vector2(x: 1, y: 1).angle(with: Vector2(x: 0, y: 1))
        XCTAssertEqualWithAccuracy(0.785398185, a, accuracy: 10e-5)
    }
}
