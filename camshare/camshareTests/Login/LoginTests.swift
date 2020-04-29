//
//  LoginTests.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/04/29.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import XCTest
import FirebaseAuth
//@testable import camshare
@testable import camPod

protocol FirUserProtocol {
    var uid: String { get}
}

extension User: FirUserProtocol {}

protocol AuthDataResultProtocol {
    var user: FirUserProtocol { get}
}

extension AuthDataResult: AuthDataResultProtocol {
    var user: FirUserProtocol {
        return self.user
    }
}

protocol FirebaseLoginAuthenticating {
    func signIn(withEmail email: String, password: String,
                completion: @escaping (AuthDataResultProtocol?, Error?) -> Void)
}

extension Auth: FirebaseLoginAuthenticating {
    func signIn(withEmail email: String, password: String,
                completion: @escaping (AuthDataResultProtocol?, Error?) -> Void) {

    }
}

class MockView: LoginViewProtocol {
    func readyForNavigation() {

    }

    func navigateToAlbumsScreen() {

    }

    func displayError(error: String) {

    }
}

class MockViewModel: LoginViewModelProtocol {
    var repo: LoginDataSourceProtocol?
    func login(email: String, password: String) {
        repo?.login(email: email, password: password, { (_, _) in

        })
    }
}

class MockLoginDataSource: LoginDataSourceProtocol {
    func login(email: String, password: String, _ completion: @escaping (String?, Bool) -> Void) {
        let authenticator: FirebaseLoginAuthenticating = Auth.auth()
        authenticator.signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(error.localizedDescription, false)
            } else {
                completion(nil, true)
            }
        }
    }
}
//swiftlint:disable all
class MockAuthDataResult: AuthDataResultProtocol {
    var user: FirUserProtocol {
        return MockUser.self as! FirUserProtocol
    }
}

class MockUser: FirUserProtocol {
    var uid: String = "thisisamockuserrepsentingfirebase"
}


class LoginTests: XCTestCase {

    var systemUnderTest: LoginViewModel?

    override func setUp() {
        systemUnderTest = LoginViewModel()
        systemUnderTest?.repo = MockLoginDataSource()
    }

    override class func tearDown() {

    }

    func testGivenUserLoginCredentialsWhenCorrectThenSuccess() {
        systemUnderTest?.login(email: "uitest@camshare.com", password: "Pass1234!")
    }
}
