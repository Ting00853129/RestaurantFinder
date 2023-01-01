//
//  RestaurantFinderApp.swift
//  RestaurantFinder
//
//  Created by Victor Tao on 2022/12/25.
//

import SwiftUI

@main
struct RestaurantFinderApp: App {
    @StateObject private var fetcher = GoogleRestaurantDataFetcher ()
    @StateObject private var user = UserFunction()
    @StateObject private var placeFinder = FavoriteFinder()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fetcher)
                .environmentObject(user)
                .environmentObject(placeFinder)
        }
    }
}
