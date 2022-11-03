//
//  SceneDelegate.swift
//  TrashMapper
//
//  Created by Jacob Case on 5/13/22.
//

import UIKit
import CoreData
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                print("user signed in")
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    let stor = UIStoryboard.init(name: "Main", bundle: nil)
                    let mainVC = stor.instantiateViewController(withIdentifier: K.StoryBoard.mainAppVC)
                    window.rootViewController = mainVC
                    self.window = window
                    window.makeKeyAndVisible()
                }
                
            } else {
                print("no user signed in")
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    let stor = UIStoryboard.init(name: "Main", bundle: nil)
                    let mainVC = stor.instantiateViewController(withIdentifier: K.StoryBoard.welcomeVC)
                    window.rootViewController = mainVC
                    self.window = window
                    window.makeKeyAndVisible()
                }
            }
        }
//        let tabController = window!.rootViewController as! UITabBarController
//        
//        if let tabViewControllers = tabController.viewControllers {
//            let navController = tabViewControllers[0] as! UINavigationController
//            
//            let controller = navController.viewControllers.first as! MapViewController
//            
//            controller.managedObjectContext = managedObjectContext
//        }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        
        /*
         14JUne2022
         Updated method below since saveContext() no longer in app delegate. Method moved to Scene delegate to handle changes within application main window
         
         Changed:
         (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
         
         To:
         saveContext()
         */
//        saveContext()
    }
    
    // MARK: - Core Data stack
    
    /*
     Comments on core data usage:
     Goal = create an NSManagedObjectContext object -> used to talk to coreData
     
     steps:
     1. Create an NSManagedObjectModel object -> data model at runtime
     2. Create an NSPersistentStoreCoordinator object -> object incharge of sqlit
     3. Create the NSManagedObjectContext -> needs to be linked to store coordinator
     
     Above 3 objects also known as "Core Data Stack"
     */
    
//    lazy var managedObjectContext = persistentContainer.viewContext
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "TrashMapper")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }


}

