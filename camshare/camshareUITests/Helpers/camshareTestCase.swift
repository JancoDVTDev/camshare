//
//  camshareTestCase.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest

// swiftlint:disable all
class camshareTestCase: XCTestCase {
// swiftlint:enable all

    var application: XCUIApplication!
    var environment: camshareTestEnvironment!

    override func setUp() {
        continueAfterFailure = false

        application = XCUIApplication()
        environment = camshareTestEnvironment(application: application)
    }

    func completeUserLoginInDetails() {
        //Without Helper Functions

        sleep(1)
        application.textFields["Email"].tap()

        application.keys["a"].tap()
        application.keys["u"].tap()
        application.keys["more"].tap()
        application.keys["@"].tap()
        application.keys["more"].tap()
        application.keys["t"].tap()
        application.keys["e"].tap()
        application.keys["s"].tap()
        application.keys["t"].tap()
        application.keys["more"].tap()
        application.keys["."].tap()
        application.keys["more"].tap()
        application.keys["c"].tap()
        application.keys["o"].tap()
        application.keys["m"].tap()

        application.secureTextFields["Password"].tap()

        application.buttons["shift"].tap()
        application.keys["P"].tap()
        application.keys["a"].tap()
        application.keys["s"].tap()
        application.keys["s"].tap()
        application.keys["more"].tap()
        application.keys["1"].tap()
        application.keys["2"].tap()
        application.keys["3"].tap()
        application.keys["4"].tap()
        application.keys["!"].tap()
        sleep(1)
    }

    //swiftlint:disable all
    func completeUserSignUpDetails() {
    //swiftlint:enable all
        sleep(1)
        application.textFields["First Name"].tap()
        application.buttons["shift"].tap()
        application.keys["P"].tap()
        application.keys["e"].tap()
        application.keys["t"].tap()
        application.keys["e"].tap()
        application.keys["r"].tap()

        application.textFields["Last Name"].tap()
        application.buttons["shift"].tap()
        application.keys["B"].tap()
        application.keys["u"].tap()
        application.keys["r"].tap()
        application.keys["c"].tap()
        application.keys["k"].tap()

        application.textFields["Email"].tap()
        application.keys["a"].tap()
        application.keys["u"].tap()
        application.keys["more"].tap()
        application.keys["@"].tap()
        application.keys["more"].tap()
        application.keys["t"].tap()
        application.keys["e"].tap()
        application.keys["s"].tap()
        application.keys["t"].tap()
        application.keys["more"].tap()
        application.keys["."].tap()
        application.keys["more"].tap()
        application.keys["c"].tap()
        application.keys["o"].tap()
        application.keys["m"].tap()

        application.secureTextFields["Password"].tap()
        application.buttons["shift"].tap()
        application.keys["P"].tap()
        application.keys["a"].tap()
        application.keys["s"].tap()
        application.keys["s"].tap()
        application.keys["more"].tap()
        application.keys["1"].tap()
        application.keys["2"].tap()
        application.keys["3"].tap()
        application.keys["4"].tap()
        application.keys["!"].tap()
        sleep(1)
    }
}
