//
//  CoreDataManager.swift
//  FirmField
//
//  Created by Renrui Liu on 12/10/18.
//  Copyright © 2018 Renrui Liu. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    // a `singleton` will live forever as long as the app is still alive
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        // init core data stack from that datamodel file
        let container = NSPersistentContainer(name: datamodelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, err) in
            if let err = err {
                print("Loading of store failed:",err)
            }
        })
        return container
    }()
}
