//
//  ContentView.swift
//  iExpense
//
//  Created by Zoltan Vegh on 15/04/2025.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text(item.type)
                        }
                        //Fix the list rows in iExpense so they read out the name and value in one single VoiceOver label, and their type in a hint.
                        .accessibilityElement()
                        .accessibilityLabel("\(item.name), \(item.type)")
                        .accessibilityHint("\(item.type)")
                        
                        Spacer()
                        
                        // Challenge 1
                        // use the user's preferred currency, rather than always using US dollars
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                        // Challenge 2
                        // modify the style based on the amount
                            .foregroundColor(item.amount < 10 ? .green : (item.amount < 100 ? .orange : .red))
                    }
                }
                .onDelete(perform: removeItems)
            }
            // Challenge 1: use navigation link instead of a sheet
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddView(expenses: expenses)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    // Challenge 3
    // split the expenses into 2 sections one for personal and one for business
    // TODO: This challenge
}

#Preview {
    ContentView()
}


/*
 I tried to do the challenge but I fucked it up, and had to revert back to the working state.
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 All three of these challenges relate to you upgrade project 7, iExpense:

 Start by upgrading it to use SwiftData.
 Add a customizable sort order option: by name or by amount.
 Add a filter option to show all expenses, just personal expenses, or just business expenses.
 */
