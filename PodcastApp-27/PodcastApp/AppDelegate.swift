//
//  AppDelegate.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 3/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()

        Theme.apply(to: window!)

        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

        PersistenceManager.shared.initializeModel(then: {
            FeedImporter.shared.startListening()
            FeedImporter.shared.updatePodcasts()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = storyboard.instantiateInitialViewController()

            let store = SubscriptionStore(context: PersistenceManager.shared.mainContext)
            do {
                if let currentStatus = try store.findCurrentlyPlayingEpisode() {
                    guard let episodeEntity = currentStatus.episode else { return }
                    let podcastEntity = episodeEntity.podcast

                    let episode = Episode(from: episodeEntity)
                    let podcast = Podcast(from: podcastEntity)

                    let playerVC = PlayerViewController.shared
                    playerVC.setEpisode(episode, podcast: podcast, autoPlay: false)

                    self.window?.rootViewController?.present(playerVC, animated: true, completion: nil)
                }
            } catch {
                print("Error trying to fetch currently playing episode.", error)
            }
        })

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        trySave()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        trySave()
    }

    private func trySave() {
        do {
            print("Saving changes...")
            try PersistenceManager.shared.mainContext.save()
        } catch {
            print("Error saving changes: ", error)
        }
    }
}

