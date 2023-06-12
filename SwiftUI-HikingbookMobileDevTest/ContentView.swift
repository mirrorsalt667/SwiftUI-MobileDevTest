//
//  ContentView.swift
//  SwiftUI-HikingbookMobileDevTest
//
//  Created by Stephen on 2023/6/11.
//

import ComposableArchitecture
import CoreData
import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.dueDate, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  let store: StoreOf<QuoteFetching>
  
  let width = UIScreen.main.bounds.width
  let rowTextPaddingWidth: CGFloat = 12
  let rowLeftRightPaddingWidth: CGFloat = 10
  
  // new Item
  @State private var itemTitle = ""
  @State private var itemDescription = ""
  @State private var itemCreatedDate = Date()
  @State private var itemDueDate = Date()
  @State private var itemLocation = ""
  
  @State private var isNewPageOpen = false
  @State private var isEditPageOpen = false
  
  var body: some View {
    NavigationView {
      VStack {
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
                NavigationLink(isActive: $isEditPageOpen) {
                  // 到下一頁的內容
                  editItemPage()
                } label: {
                  VStack {
                    Text(item.title ?? "")
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
        ZStack {
          WithViewStore(store) { $0
          } content: { viewStore in
            
            Rectangle()
              .frame(height: 100)
              .onAppear {
                viewStore.send(.getQuoteAction)
              }
            Text(
              (viewStore.quoteSentence ?? "API Failed")
            )
              .foregroundColor(.white)
          }
        }
      }
      .toolbar {
        ToolbarItem {
          NavigationLink(isActive: $isNewPageOpen) {
            // 到下一頁的內容
            newItemPage()
          } label: {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      Text("Select an item")
    }
  }
  
  // MARK: - ViewBuild
  
  @ViewBuilder
  private func newItemPage() -> some View {
    VStack {
      HStack {
        Text("Title: ")
        TextField("ex: See a ductor.", text: $itemTitle)
          .border(.black)
      }
      .padding(5)
      HStack {
        Text("Description: ")
        TextField("ex: Take the Bus 123.", text: $itemDescription)
          .border(.black)
      }
      .padding(5)
      HStack {
        Text("Create Date: ")
        DatePicker(selection: $itemCreatedDate) {
//          Text("\(itemCreatedDate, formatter: itemFormatter)")
        }
      }
      .padding(5)
      HStack {
        Text("Due Date: ")
        DatePicker(selection: $itemDueDate) {
//          Text("\(itemCreatedDate, formatter: itemFormatter)")
        }
      }
      .padding(5)
      HStack {
        Text("Location: ")
        TextField("ex: 25.0174719, 121.3662922.", text: $itemLocation)
          .border(.black)
      }
      .padding(5)
      Button {
        isNewPageOpen = false
        addItem()
      } label: {
        Text("新增To-Do List")
          .padding(5)
      }
      .border(.black)
      Color.white
    }
  }
  
  private func editItemPage() -> some View {
    VStack {
      HStack {
        Text("Title: ")
        TextField("ex: See a ductor.", text: $itemTitle)
          .border(.black)
      }
      .padding(5)
      HStack {
        Text("Description: ")
        TextField("ex: Take the Bus 123.", text: $itemDescription)
          .border(.black)
      }
      .padding(5)
      HStack {
        Text("Create Date: ")
        DatePicker(selection: $itemCreatedDate) {
//          Text("\(itemCreatedDate, formatter: itemFormatter)")
        }
      }
      .padding(5)
      HStack {
        Text("Due Date: ")
        DatePicker(selection: $itemDueDate) {
//          Text("\(itemCreatedDate, formatter: itemFormatter)")
        }
      }
      .padding(5)
      HStack {
        Text("Location: ")
        TextField("ex: 25.0174719, 121.3662922.", text: $itemLocation)
          .border(.black)
      }
      .padding(5)
      Button {
        isEditPageOpen = false
      } label: {
        Text("刪除To-Do List")
          .padding(5)
      }
      .border(.black)
      Color.white
    }
  }

  // MARK: - Methods
  
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.title = itemTitle
      newItem.descriptionString = itemDescription
      newItem.createdDate = itemCreatedDate
      newItem.dueDate = itemDueDate
      newItem.location = itemLocation
      
      do {
        try viewContext.save()
      } catch {
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
      ContentView(store: Store(initialState: QuoteFetching.State(), reducer: {
        QuoteFetching {
//          if let url = URL(string: quoteUrlString),
//             let (data, _) = try? await URLSession.shared.data(from: url) {
//            let decoding = JSONDecoder()
//            let decodingData = try? decoding.decode(QuoteType.self, from: data)
//            return decodingData
//          } else {
            return nil
//          }
        }
      })).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
