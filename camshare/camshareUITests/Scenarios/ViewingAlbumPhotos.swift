//
//  ViewingAlbumPhotos.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/04/29.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation
import XCTest
@testable import camPod

class ViewwingAlbumPhotos: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }

    override class func tearDown() {

    }

    func testGivenUserViewSelectedAlbumWhenTappedOnAlbumThenDisplayAlbum() {
        app.launch()
        loginUser()
        sleep(3)
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.staticTexts["UITEST243"].tap()
        sleep(1)
        XCTAssert(collectionViewsQuery.cells.children(matching: .other).element.children(matching:
            .other).element.exists)
        app.navigationBars["UITEST243"].buttons["My Albums"].tap()
        sleep(1)
        signoutUser()
    }

    func testGivenViewSelectedPhotoWhenPhotoTappedThenViewPhoto() {
        app.launch()
        sleep(2)
        loginUser()
        sleep(3)
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.staticTexts["UITEST243"].tap()
        collectionViewsQuery.cells.children(matching: .other).element.children(matching: .other).element.tap()
        sleep(1)
        app.navigationBars["SelectedImageObjCView"].buttons["UITEST243"].tap()
        sleep(1)
        app.navigationBars["UITEST243"].buttons["My Albums"].tap()
        sleep(1)
        signoutUser()
    }

    func testGivenUserShareAlbumWhenShareButtonTappedThen() {
        app.launch()
        sleep(2)
        loginUser()
        sleep(3)
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells.staticTexts["UITEST243"].tap()//
        sleep(1)
        app.toolbars["Toolbar"].buttons["Share"].tap()
        app.sheets["Share Album"].scrollViews.otherElements.buttons["Generate QR Code"].tap()
        sleep(1)
        XCTAssert(app.staticTexts["How To Add Album"].exists)
        app.navigationBars["QR Code"].buttons["UITEST243"].tap()
        app.navigationBars["UITEST243"].buttons["My Albums"].tap()
        app.navigationBars["My Albums"].buttons["person.circle"].tap()
        app.sheets["Confirm"].scrollViews.otherElements.buttons["Sign Out"].tap()
    }

    func testRecord() {

    }

    func loginUser() {
        app.buttons["Login"].tap()
        sleep(1)
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("uitest@camshare.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Pass1234!")
        app.buttons["Login"].tap()
        sleep(3)
    }

    func signoutUser() {
        let app = XCUIApplication()
        app.navigationBars["My Albums"].buttons["person.circle"].tap()
        app.sheets["Confirm"].scrollViews.otherElements.buttons["Sign Out"].tap()
    }
}
