//
//  LoginUser.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest

class LoginUser: camshareTestCase {

    func testUserLogin() {
        application.launch()
        environment.setUpWith(username: "au@test.com", password: "Pass1234!")

        application.buttons["Login"].tap()
        completeUserLoginInDetails()
        application.buttons["Login"].tap()
        sleep(2)
        XCTAssert(application.navigationBars["My Albums"].buttons["Add"].exists)
    }

    func testRecord() {

    }
}
