//
//  AppDelegate.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/24.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var blockRotation: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 255/255.0, green:
            255/255.0, blue: 255/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        if let barFont = UIFont(name: "Futura", size: 24.0) { UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:barFont] }
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        //key
        //self.edu.Memo
        AMapServices.shared().apiKey = "e65700d588068f4491d28708b506048d"
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation{
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.portrait
        }
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Memo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
    func addToContext(memoContent: String, photo: UIImage?, time: String?, day: String?, hour: String?, minute: String?, year: String?,month: String?,date: String?,memoColor: String?) -> MemoDataMO {
        let memo = MemoDataMO(context: persistentContainer.viewContext)
        memo.memoContent = memoContent
        if let photo = photo {
            if photo == nil {
                memo.memoImage = UIImagePNGRepresentation(UIImage(named: "photoalbum")!)
            } else {
            memo.memoImage = UIImagePNGRepresentation(photo)
            
            }
        }
        memo.memoTime = time
        memo.memoDay = day
        memo.memoColor = memoColor
        memo.memoHour = hour
        memo.memoMinute = minute
        memo.memoYear = year
        memo.memoMonth = month
        memo.memoDate = date
//        if let photo = photo {
//            person.photo = UIImagePNGRepresentation(photo) }

        print("Saving new memo to context ...")
        saveContext()
        return memo
    }
    
    func fetchContext() -> [MemoDataMO]? {
        var fetchedList:[MemoDataMO]? = nil
        do {
            fetchedList = try persistentContainer.viewContext.fetch(MemoDataMO.fetchRequest()) as?[MemoDataMO]
        } catch {
            print("Failed to fetch employees: \(error)")
        }
        return fetchedList
    }

    func deleteFromContext(memo: MemoDataMO) {
        persistentContainer.viewContext.delete(memo)
        print("deleting the person from context ...")
        saveContext()
    }

    func updateToContext(memo: MemoDataMO, content: String,photo: UIImage?, time: String?, day: String?,hour: String?, minute: String?, year: String?,month: String?,date: String?, memoColor: String?) {
        memo.memoContent = content
        if let mPhoto = photo {
            if mPhoto == nil {
                memo.memoImage = UIImagePNGRepresentation(UIImage(named: "photoalbum")!)
            } else {
            memo.memoImage = UIImagePNGRepresentation(mPhoto)
            }
        }
        memo.memoTime = time
        memo.memoDay = day
        memo.memoColor = memoColor
        memo.memoHour = hour
        memo.memoMinute = minute
        memo.memoYear = year
        memo.memoMonth = month
        memo.memoDate = date

        print("updating the person to context ...")
        saveContext()
    }

}

