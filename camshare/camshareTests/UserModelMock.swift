//
//  UserModelMock.swift
//  camshareTests
//
//  Created by Janco Erasmus on 2020/03/09.
//  Copyright © 2020 DVT. All rights reserved.
//

import Foundation

@testable import camPod
@testable import camshare

public class UserModelMock {
//    public var name = "Janco"
//    public var surname = "Erasmus"
//
//    public var email = "jancoera@gmail.com"
//    public var password = "Pass1234!"
}

extension UserModelMock: UserModelProtocol {
    public func login(email: String, password: String, _ completion: @escaping (Bool, User?) -> Void) {
        
    }

    public func signUp(firstName: String, lastName: String, email: String,
                       password: String, _ completion: @escaping (User?) -> Void) {
        
    }
    
//    public func login(email: String, password: String, _ completion: @escaping (Bool, User?) -> Void) {
//        
//    }
//    
//    public func signUp(firstName: String, lastName: String, email: String,
//                       password: String, _ completion: @escaping (User?) -> Void) {
//        
//    }
//    
//    public func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        //do some validation with username and password
//        if email == "jancoera@gmail.com" && password == "Pass1234!" {
//            print("User logged in")
//             completion(true)
//        } else {
//            print("User login fails")
//            completion(false)
//        }
//    }
//
//    public func signUp(name: String, and surname: String, with email: String, and password: String,
//                       _ completion: @escaping (Bool) -> Void) {
//        if name == "Janco" && surname == "Erasmus" && email == "jancoera@gmail.com" && password == "Pass1234!" {
//            print("User logged in")
//             completion(true)
//        } else {
//            print("User login fails")
//            completion(false)
//        }
//    }

}
