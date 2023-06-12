//
//  SwiftUI_HikingbookMobileDevTestApp.swift
//  SwiftUI-HikingbookMobileDevTest
//
//  Created by Stephen on 2023/6/11.
//

import ComposableArchitecture
import SwiftUI

@main
struct SwiftUI_HikingbookMobileDevTestApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView(store: Store(initialState: QuoteFetching.State(), reducer: {
        QuoteFetching {
          if let url = URL(string: quoteUrlString),
             let (data, _) = try? await URLSession.shared.data(from: url) {
            let decoding = JSONDecoder()
            return try? decoding.decode(QuoteType.self, from: data)
          } else {
            return nil
          }
        }
      }))
      .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
