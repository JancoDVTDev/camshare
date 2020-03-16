//
//  camshareTestEnvironment.swift
//  camshareUITests
//
//  Created by Janco Erasmus on 2020/03/16.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation
import XCTest

@testable import camshare
// swiftlint:disable all
struct camshareTestEnvironment {
// swiftlint:enable all
    let application: XCUIApplication!

    init (application: XCUIApplication) {
        self.application = application
        self.application.launchArguments += ["-delay", "0"]
    }

    func setUpWith(username: String, password: String) {
        application.launchArguments += ["-initial.user.name", username]
        application.launchArguments += ["-initial.user.password", password]
    }

    func signUpUserWith(firstName: String, lastName: String, email: String, password: String) {
        application.launchArguments += ["-initial.user.firstName", firstName]
        application.launchArguments += ["-initial.user.lastName", lastName]
        application.launchArguments += ["-initial.user.email", email]
        application.launchArguments += ["-initial.user.password", password]
    }
}
