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
    static let albumName = "UITEST"

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }

    func testGivenUserTapsPlusIconThenActionSheetAppears() {
        app.launch()
        loginUser()
        sleep(3)
        app.navigationBars["My Albums"].buttons["Add"].tap()
        snapshot("MyAlbums")
        sleep(1)
        snapshot("MyAlbums_AddSheet")

        XCTAssert(app.sheets["Add Album"].exists)
        app.sheets.buttons["Cancel"].tap()
        signoutUser()
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
        let title = "UITEST" + String(randomInt)
        app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].typeText(title)
        sleep(1)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: title)
        snapshot("MyAlbums_AddCreateNewAlert")

        XCTAssert(app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].exists)

        signoutUser()
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
        app.alerts["Existing Album"].scrollViews.otherElements
            .textFields["Album ID"].typeText("AlbumID must be typed")
        snapshot("MyAlbums_AddExisting")

        XCTAssert(app.alerts["Existing Album"].scrollViews.otherElements.textFields["Album ID"].exists)

        signoutUser()
    }

    func testGivenCreatingOrDeletingAlbumWhenAddOrDeleteTappedThenAlbumIsAddedOrDeleted() {
        app.launch()
        loginUser()
        sleep(3)
        addTapped()
        sleep(1)
        app.sheets["Add Album"].scrollViews.otherElements.buttons["Create New"].tap()
        sleep(1)
        app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].tap()
        let title = "UITEST"
        app.alerts["New Album"].scrollViews.otherElements.textFields["Title"].typeText(title)
        // MARK: WRITE: DATABASE WILL BE USED
        app.alerts["New Album"].scrollViews.otherElements.buttons["Save"].tap()
        sleep(2)
        let addedAlbumPre = app.collectionViews.cells.otherElements.containing(.staticText, identifier: title)
        let addedAlbum = addedAlbumPre.children(matching: .other).element.children(matching: .image).element

        // MARK: Deleting
        let myAlbumsNavigationBar = app.navigationBars["My Albums"]
        let selectButton = myAlbumsNavigationBar.buttons["Select"]
        selectButton.tap()

        addedAlbum.tap()

        myAlbumsNavigationBar.buttons["Delete"].tap()
        app.sheets["Delete Album ?"].scrollViews.otherElements.buttons["Delete"].tap()
        myAlbumsNavigationBar.buttons["Cancel"].tap()
        signoutUser()
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

    func addTapped() {
        app.navigationBars["My Albums"].buttons["Add"].tap()
        sleep(1)
    }
}
