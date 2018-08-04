//
//  CoreDataManager.swift
//  FinalApp
//

import CoreData

struct CoreDataManager {
    // singleton (to mantain the context across the app)
    // it will live forever as long as the app still alive
    // its properties will too
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        // initialization of Core Data stack
        let container = NSPersistentContainer(name: "FinalApp")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchBusinessCards() -> [BusinessCard] {
        //attempt core data fetch
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<BusinessCard>(entityName: "BusinessCard")
        
        do {
            let businessCards = try context.fetch(fetchRequest)
            // check business cards on the screen and business cards on the console are the same
            businessCards.forEach { (businessCard) in
                print(businessCard.fullName ?? "")
            }
            return businessCards
        } catch let fetchErr {
            print("Failed to fetch business cards: \(fetchErr)")
            return []
        }
    }
    
}
