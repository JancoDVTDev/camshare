//
//  LoginUser.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest
import FirebaseAuth

class LoginUser: camshareTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        setupSnapshot(app)
        continueAfterFailure = false
    }

    override class func tearDown() {
    }

    func testGivenUserLoginWhenCredentialsAreCorrectThenLoginSuccesful() {
        app.launch()
        snapshot("Login")
        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("uitest@camshare.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234!")
        app.buttons["Login"].tap()

        snapshot("Login_Suceeded")
        sleep(3)
        XCTAssert(app.navigationBars["My Albums"].exists)

        signoutUser()
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectEmailThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtttest.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234!")
        app.buttons["Login"].tap()
        sleep(3)
        snapshot("Login_EmailWrong")
        XCTAssert(app.staticTexts["The email address is badly formatted."].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordLengthThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("esne@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass")
        app.buttons["Login"].tap()
        sleep(3)
        snapshot("Login_PasswordFailed")
        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordSpecialThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("esne@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordCapitalThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("p@ss1234")
        app.buttons["Login"].tap()
        sleep(3)

        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
    }

    func testGivenUserLoginWhenCredentialsAreIncorrectPasswordNumberThenLoginUnsuccesful() {
        app.launch()

        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("P@ssword")
        app.buttons["Login"].tap()
        sleep(4)

        XCTAssert(app.staticTexts["The password is invalid or the user does not have a password."].exists)
    }

    func testRecord() {

    }
    func signoutUser() {
        let app = XCUIApplication()
        app.navigationBars["My Albums"].buttons["person.circle"].tap()
        app.sheets["Confirm"].scrollViews.otherElements.buttons["Sign Out"].tap()
    }
}
