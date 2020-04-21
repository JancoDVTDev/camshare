//
//  AppDelegate.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/07.
//  Copyright © 2020 DVT. All rights reserved.
//

var images = [UIImage(named: "image-1"), UIImage(named: "Image2"), UIImage(named: "Image3"),
UIImage(named: "Image4"), UIImage(named: "Image5"), UIImage(named: "Image6"),
UIImage(named: "Image7"), UIImage(named: "Image8"), UIImage(named: "Image9"),
UIImage(named: "Image10"), UIImage(named: "Image11"), UIImage(named: "Image12")]

import UIKit
import Firebase
import CoreData
import camPod

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SavedImagesType {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after
        // application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Core data required functions
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "SavedImages")
      container.loadPersistentStores(completionHandler: { (_, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func returnContainer() -> NSPersistentContainer {
        return persistentContainer
    }
}
