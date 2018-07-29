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
}
