//
//  NSManagedObjectModel+Ext.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import CoreData

extension NSManagedObjectModel {
    /// The method is designed to create and return an NSManagedObjectModel object from a .momd file. This file is a compiled version of the Core Data model created in Xcode.
    /// - Parameters:
    ///   - name: A String representing the name of the Core Data model file (without the file extension).
    ///   - bundle: A Bundle object where the model file is located. Typically, this is the main bundle of the application.
    /// - Returns: NSManagedObjectModel?
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}


