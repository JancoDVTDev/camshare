//
//  CamshareAPITest.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/04/29.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation
import XCTest
import OHHTTPStubs
@testable import camPod
@testable import camshare

class CamShareAPITest: XCTestCase {
    var condition = 0
    var systemUnderTest: camshareAPIGet?
    override func setUp() {
        stub(condition: isHost("camshareapi.herokuapp.com")) { _ in
            switch self.condition {
            case 0:
                let stubPath = OHPathForFile("MockTips.json", type(of: self))
                return HTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            default:
                let stubPath = OHPathForFile("MockTips.json", type(of: self))
                return HTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            }
        }
    }

    override class func tearDown() {

    }

    func testGivenCallToCamshareAPIWhenTipsRequestedThenLoadTips() {
        condition = 0
        systemUnderTest = camshareAPIGet()
        systemUnderTest?.fetchTipsAndTricks({ (tipsAndTricks, error) in
            if let error = error {
                XCTFail(error)
            } else {
                XCTAssertTrue(tipsAndTricks!.count == 2)
            }
        })
    }
}
