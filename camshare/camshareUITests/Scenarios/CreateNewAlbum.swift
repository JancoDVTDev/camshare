//
//  CreateNewAlbum.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest

class CreateNewAlbum: camshareTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }
    
    func testGivenUserTapsPlusIconThenActionSheetAppears() {
        app.launch()
        loginUser()
        sleep(2)
        app.navigationBars["My Albums"].buttons["Add"].tap()
        sleep(1)

        XCTAssert(app.sheets["Add Album"].exists)
    }
    
    func testGivenUserTapsCreateNewThenAlertSheetAppears() {
        app.launch()
        loginUser()
        sleep(3)
        addTapped()
        sleep(1)
        app.sheets["Add Album"].scrollViews.otherElements.buttons["Create New"].tap()
        sleep(1)
        app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].tap()
        let randomInt = Int.random(in: 100...900)
        let title = "TST" + String(randomInt)
        app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].typeText(title)
        // MARK: WRITE: DATABASE WILL BE USED
//        app.alerts["New Album"].scrollViews.otherElements.buttons["Save"].tap()
//        sleep(2)
//        let addedAlbumPre = app.collectionViews.cells.otherElements.containing(.staticText, identifier: title)
//        let addedAlbum = addedAlbumPre.children(matching: .other).element.children(matching: .image).element
        
        XCTAssert(app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].exists)
    }

    func testGivenUserTapsExistingAlbumThenAlertSheetAppears() {
        app.launch()
        loginUser()
        sleep(3)
        addTapped()
        sleep(1)
        app.sheets["Add Album"].scrollViews.otherElements.buttons["Existing Album"].tap()
        sleep(1)
        app.alerts["Existing Album"].scrollViews.otherElements.textFields["Album ID"].tap()
        // MARK: WRITE: DATABASE WILL BE USED
        //Paste a real ID
        app.alerts["Existing Album"].scrollViews.otherElements.textFields["Album ID"].typeText("AlbumID must be typed")
        
        XCTAssert(app.alerts["Existing Album"].scrollViews.otherElements.textFields["Album ID"].exists)
    }

    func testRecord() {

    }

    func loginUser() {
        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("urtt@test.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234!")
        app.buttons["Login"].tap()
        sleep(3)
    }

    func addTapped() {
        app.navigationBars["My Albums"].buttons["Add"].tap()
        sleep(1)
    }
}
