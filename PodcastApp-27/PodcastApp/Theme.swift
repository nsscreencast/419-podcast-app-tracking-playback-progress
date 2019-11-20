//
//  Theme.swift
//  PodcastApp
//
//  Created by Ben Scheirman on 3/7/19.
//  Copyright © 2019 NSScreencast. All rights reserved.
//

import UIKit

struct Theme {
    static func apply(to window: UIWindow) {
        window.tintColor = Colors.purple

        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = Colors.gray4

        let navBar = UINavigationBar.appearance()
        navBar.barStyle = .black
        navBar.barTintColor = Colors.gray4
        navBar.titleTextAttributes = [.foregroundColor : Colors.gray0]

        let searchBarTextFields = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchBarTextFields.defaultTextAttributes = [
            .foregroundColor : Colors.gray1,
            .font : UIFont.boldSystemFont(ofSize: 14)
        ]
    }

    struct Colors {
        static var gray0 = UIColor(hue:0.00, saturation:0.00, brightness:0.85, alpha:1.00)
        static var gray1 = UIColor(hue:0.67, saturation:0.03, brightness:0.58, alpha:1.00)
        static var gray2 = UIColor(hue:0.67, saturation:0.08, brightness:0.33, alpha:1.00)
        static var gray3 = UIColor(hue:0.00, saturation:0.00, brightness:0.15, alpha:1.00)
        static var gray4 = UIColor(hue:0.00, saturation:0.00, brightness:0.11, alpha:1.00)
        static var gray5 = UIColor(hue:0.75, saturation:0.10, brightness:0.08, alpha:1.00)

        static var purple = UIColor(hue:0.73, saturation:0.78, brightness:0.98, alpha:1.00)
        static var purpleLight = UIColor(hue:0.70, saturation:0.28, brightness:0.71, alpha:1.00)
        static var purpleBright = UIColor(red: 0.63, green: 0.06, blue: 1.00, alpha: 1.00)
        static var purpleDimmed = UIColor(red: 0.30, green: 0.04, blue: 0.53, alpha: 1.00)

    }
}
