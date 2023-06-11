//
//  ContentView.swift
//  SwiftUI-HikingbookMobileDevTest
//
//  Created by Stephen on 2023/6/11.
//

import SwiftUI
import Foundation
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.title, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
  
  let width = UIScreen.main.bounds.width
  let rowTextPaddingWidth: CGFloat = 12
  let rowLeftRightPaddingWidth: CGFloat = 10
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(spacing: 10) {
          ForEach(items) { item in
            ZStack {
              HStack(spacing: 0) {
                Color.white
                  .padding()
                  .frame(width: rowLeftRightPaddingWidth)
                RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 1)
                  .foregroundColor(.black)
                Color.white
                  .padding()
                  .frame(width: rowLeftRightPaddingWidth)
              }
                NavigationLink {
                  // 到下一頁的內容
                  Text("Item at \(item.dueDate ?? Date(), formatter: itemFormatter)")
                } label: {
                  VStack {
                    Text(item.title ?? "111")
                      .frame(width: (width-rowTextPaddingWidth*2), alignment: .leading)
                      .foregroundColor(.black)
                    Text("Due Date: \(item.dueDate ?? Date(), formatter: itemFormatter)")
                      .frame(width: (width-rowTextPaddingWidth*2), alignment: .leading)
                      .foregroundColor(Color(red: 0.675, green: 0.255, blue: 0.255))
                  }
                }
                .padding(EdgeInsets(top: 10, leading: rowTextPaddingWidth, bottom: 10, trailing: rowTextPaddingWidth))
              }
            
          }
          .onDelete(perform: deleteItems)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
  }

  // MARK: - Methods
  
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.title = "See a doctor."
      newItem.createdDate = Date()
      
      do {
        try viewContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//class ToDoList: NSManagedObject {
//  var title: String
////  var description: String
//  var createdDate: Date
////  var dueDate: Date
////  var location: String
//
//  init(title: String, createdDate: Date) {
//    self.title = title
//    self.createdDate = createdDate
//  }
//}
