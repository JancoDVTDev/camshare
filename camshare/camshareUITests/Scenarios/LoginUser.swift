//
//  LoginUser.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest

class LoginUser: camshareTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }

    func testGivenUserLoginWhenCredentialsAreCorrectThenLoginSuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234!")
        app.buttons["Login"].tap()
        sleep(3)
        
        XCTAssert(app.navigationBars["My Albums"].buttons["Add"].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectEmailThenLoginUnsuccesful() {
//        app.launch()
//
//        app.buttons["Login"].tap()
//        sleep(1)
//        app.textFields["Email"].tap()
//        app.textFields["Email"].typeText("urtttest.com")
//        app.secureTextFields["Password"].tap()
//        app.secureTextFields["Password"].typeText("Pass1234!")
//        app.buttons["Login"].tap()
//        sleep(3)
//        
//        XCTAssert(app.staticTexts["Email not valid format"].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordLengthThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["Password at least 8 characters"].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordSpecialThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["No SPECIAL CHARACTER"].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordCapitalThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("p@ss1234")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["No CAPITAL LETTER"].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordNumberThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("P@ssword")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["No NUMBER"].exists)
    }

    func testRecord() {

    }
}
