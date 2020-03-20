//
//  SignUpLoginViewModelTests.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/03/09.
//  Copyright © 2020 DVT. All rights reserved.
//

import XCTest
@testable import camPod
@testable import camshare

class SignUpLoginViewModelTests: XCTestCase {
    var systemUnderTest: UserSignUpLoginViewModel!
    weak var repo: UserModelProtocol!
    let userModelMock = UserModelMock()

    override func setUp() {
        systemUnderTest = UserSignUpLoginViewModel(repo: repo)
    }

    // MARK: Login Tests
    func testGivenCorrectUsernameAndPasswordThenLogUserIn() {
        var succesfulLogin = false
        userModelMock.login(email: "jancoera@gmail.com", password: "Pass1234!") { (loginStatus) in
            succesfulLogin = loginStatus
        }
        XCTAssert(succesfulLogin)
    }

    func testGivenCorrectUsernameAndIncorrectPasswordThenDisplayMessageToUser() {
        var unSuccesfulLogin = false
        userModelMock.login(email: "jancoera@gmail.com", password: "Pass") { (loginStatus) in
            if !loginStatus {
                unSuccesfulLogin = true
            }
        }
        XCTAssert(unSuccesfulLogin)
    }

    func testGivenIncorrectUsernameAndCorrectPasswordThenDisplayMessageToUser() {
        var unSuccesfulLogin = false
        userModelMock.login(email: "ronald@gmail.com", password: "Pass1234!") { (loginStatus) in
            if !loginStatus {
                unSuccesfulLogin = true
            }
        }
        XCTAssert(unSuccesfulLogin)
    }

    func testGivenIncorrectUsernameAndIncorrectPasswordThenDisplayMessageToUser() {
        var unSuccesfulLogin = false
        userModelMock.login(email: "ronald@gmail.com", password: "Pass") { (loginStatus) in
            if !loginStatus {
                unSuccesfulLogin = true
            }
        }
        XCTAssert(unSuccesfulLogin)
    }

    // MARK: SignUp Tests

    func testGivenCorrectNameSurnameUsernamePassword() {
        var succesfulCreatedUser = false
        userModelMock.signUp(name: "Janco", and: "Erasmus",
                             with: "jancoera@gmail.com", and: "Pass1234!") { (signUpStatus) in
            if signUpStatus {
                succesfulCreatedUser = true
            }
        }
        XCTAssert(succesfulCreatedUser)
    }

    func testGivenIncorrectNameAndCorrectSurnameUsernamePassword() {
        var unSuccesfulUserCreated = false
        userModelMock.signUp(name: "Ronald", and: "Erasmus",
                             with: "jancoera@gmail.com", and: "Pass1234!") { (signUpStatus) in
            if !signUpStatus {
                unSuccesfulUserCreated = true
            }
        }
        XCTAssert(unSuccesfulUserCreated)
    }

    func testGivenCorrectNameAndIncorrectSurnameAndCorrectUsernamePassword() {
        var unSuccesfulUserCreated = false
        userModelMock.signUp(name: "Janco", and: "Raygen",
                             with: "jancoera@gmail.com", and: "Pass1234!") { (signUpStatus) in
            if !signUpStatus {
                unSuccesfulUserCreated = true
            }
        }
        XCTAssert(unSuccesfulUserCreated)
    }

    func testGivenCorrectNameAndSurnameAndIncorrectUsernameCorrectPassword() {
        var unSuccesfulUserCreated = false
        userModelMock.signUp(name: "Janco", and: "Erasmus",
                             with: "ronald@gmail.com", and: "Pass1234!") { (signUpStatus) in
            if !signUpStatus {
                unSuccesfulUserCreated = true
            }
        }
        XCTAssert(unSuccesfulUserCreated)
    }

    func testGivenCorrectNameAndSurnameAndUsernameIncorrectPassword() {
        var unSuccesfulUserCreated = false
        userModelMock.signUp(name: "Janco", and: "Erasmus",
                             with: "ronald@gmail.com", and: "Pass") { (signUpStatus) in
            if !signUpStatus {
                unSuccesfulUserCreated = true
            }
        }
        XCTAssert(unSuccesfulUserCreated)
    }
}
