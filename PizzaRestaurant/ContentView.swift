//
//  ContentView.swift
//  PizzaRestaurant
//
//  Created by Anthony Gibson on 29/12/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
  //MARK: - Properties
  @State var showOrderSheet = false
  
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(entity: Order.entity(), sortDescriptors: [])
  //@FetchRequest(entity: Order.entity(), sortDescriptors: [], predicate: NSPredicate(format: "status != %@", Status.completed.rawValue))
  
  var orders: FetchedResults<Order>
  
  //MARK: - Body
  var body: some View {
    NavigationView {
      List {
        ForEach(orders) { order in
          HStack {
            VStack (alignment: .leading){
              Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                .font(.headline)
              Text("Table \(order.tableNumber)")
                .font(.subheadline)
            }//: VSTACK
            Spacer()
            Button(action: {
              updateOrder(order: order)
            }) {
              Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                .foregroundColor(.blue)
            }
          }//: HSTACK
          .frame(height: 50)
        }//ForEach
        .onDelete { indexSet in
          for index in indexSet {
            viewContext.delete(orders[index])
          }
          do {
            try viewContext.save()
          } catch {
            print(error.localizedDescription)
          }
        }
      }//:List
      .listStyle(PlainListStyle())
      
      .sheet(isPresented: $showOrderSheet) {
        OrderSheet()
      }
      .navigationTitle("My Orders")
      .navigationBarItems(trailing: Button(action: {
        showOrderSheet = true
        print("open order sheet")
      }, label: {
        Image(systemName: "plus.circle")
          .imageScale(.large)
      }))
    }//:NavigationView
  }
  func updateOrder(order: Order) {
    let newStatus = order.orderStatus == .pending ? Status.preparing : .completed
    viewContext.performAndWait {
      order.orderStatus = newStatus
      try? viewContext.save()
    }
  }//: func - updateOrder
}




//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewDevice("iPhone 11")
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}


