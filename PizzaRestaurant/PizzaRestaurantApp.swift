//
//  PizzaRestaurantApp.swift
//  PizzaRestaurant
//
//  Created by Anthony Gibson on 29/12/2020.
//

import SwiftUI

@main
struct PizzaRestaurantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
