//
//  SwiftUI_HikingbookMobileDevTestApp.swift
//  SwiftUI-HikingbookMobileDevTest
//
//  Created by Stephen on 2023/6/11.
//

import SwiftUI

@main
struct SwiftUI_HikingbookMobileDevTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
