//
//  AppDelegate.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Register default UserDefault values
        UserDefaults.standard.register(defaults: [
            "leagues": [
                "bundesliga": [
                    "id": 78,
                    "displayName": "Bundesliga",
                    "isSelected": false
                ],
                "laLiga": [
                    "id": 140,
                    "displayName": "LaLiga",
                    "isSelected": false
                ],
                "ligue1": [
                    "id": 61,
                    "displayName": "Ligue 1",
                    "isSelected": false
                ],
                "mls": [
                    "id": 253,
                    "displayName": "Major League Soccer",
                    "isSelected": false
                ],
                "premierLeague": [
                    "id": 39,
                    "displayName": "Premier League",
                    "isSelected": false
                ],
                "serieA": [
                    "id": 135,
                    "displayName": "Serie A",
                    "isSelected": false
                ]
            ] as [String: [String: Any]],
            "settings": [
                "leagueOptions": [
                    "defaultLeague": [
                        "bundesliga": false,
                        "laLiga": false,
                        "ligue1": false,
                        "mls": false,
                        "premierLeague": true,
                        "serieA": false
                    ],
                ],
                "displayOptions": [
                    "theme": [
                        "system": true,
                        "light": false,
                        "dark": false
                    ],
                    "locale": [
                        "system": true
                    ]
                ]
            ]
        ])
        
        let userDefaultsContext = UserDefaultsContext()
        
        // Get default league from UserDefaults
        let defaultLeague = userDefaultsContext.getEnabledSelection(groupKey: "leagueOptions", optionKey: "defaultLeague")
        guard let defaultLeague = defaultLeague else {
            return true
        }
        
        // Reset selected league to default
        userDefaultsContext.setSelectedLeague(as: defaultLeague)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Footi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let store = container.viewContext.persistentStoreCoordinator?.persistentStores.first {
//                print("here")
//                if let url = container.viewContext.persistentStoreCoordinator?.url(for: store) {
//                    let fileManager = FileManager.default
//
//                    do {
//                        try fileManager.removeItem(at: url)
//                        print("Persistent store deleted.")
//                    } catch {
//                        print("Failed to delete persistent store: \(error)")
//                    }
//                }
//            }
            
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

