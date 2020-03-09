//
//  camshareTests.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest
@testable import camshare
@testable import camPod
//swiftlint:disable all
class camshareTests: XCTestCase {
//swiftlint:enable all
    var systemUnderTest: ShowingAllUserAlbumsViewModel!
    override func setUp() {
        systemUnderTest = ShowingAllUserAlbumsViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testGivenANewAlbumThenGenerateAUniqiueAlbumID() {
        let uniqueID = systemUnderTest.generateUniqueAlbumID()
        var flag: Bool = false
        
        if uniqueID.count == 25 {
            flag = true
        }else {
            flag = false
        }
        
        XCTAssert(flag)
        //XCTAssertEqual(uniqueID, uniqueID)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
