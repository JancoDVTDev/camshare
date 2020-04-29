//
//  YoutubeAPITest.swift
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

class YoutubeAPITest: XCTestCase {
    var condition = 0
    var systemUnderTest: YoutubeDataAPI?
    override func setUp() {
        stub(condition: isHost("www.googleapis.com")) { _ in
            switch self.condition {
            case 0:
                let stubPath = OHPathForFile("MockYoutubeResults.json", type(of: self))
                return HTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            default:
                let stubPath = OHPathForFile("MockYoutubeResults.json", type(of: self))
                return HTTPStubsResponse(fileAtPath: stubPath!, statusCode: 200,
                                         headers: ["Content-Type": "application/json"])
            }
        }
    }

    func testGivenVideosRequestedWhenVideosTappedThenLoadVideosFromYoutube() {
        condition = 0
        systemUnderTest = YoutubeDataAPI()
        systemUnderTest?.fetchYoutubeTips({ (results, error) in
            if let error = error {
                XCTFail(error)
            } else {
                XCTAssertTrue(results?.count == 2)
            }
        })
    }
}
