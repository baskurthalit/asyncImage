//
//  NSPersistentContainer+Ext.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import CoreData

extension NSPersistentContainer {
    /// Loads an `NSPersistentContainer` with the specified name, model, and store URL.
    ///
    /// This method creates an `NSPersistentContainer` using the provided name and `NSManagedObjectModel`,
    /// configures it with a persistent store located at the specified URL, and loads the persistent stores.
    ///
    /// - Parameters:
    ///   - name: The name of the persistent container. This is typically the name of the Core Data model file.
    ///   - model: The `NSManagedObjectModel` to be used by the container.
    ///   - url: The URL where the persistent store will be located.
    /// - Throws: An error if the persistent store could not be loaded.
    /// - Returns: A fully configured and loaded `NSPersistentContainer`.
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        
        return container
    }
}
