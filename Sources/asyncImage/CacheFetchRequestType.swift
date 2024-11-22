//
//  CacheFetchRequest.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import CoreData

enum CacheFetchRequestType {
    case find
    case delete
    
    func nsRequest(for query: Any) -> NSFetchRequest<ImageEntity>? {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        switch self {
        case .find:
            guard let query = query as? String else { return nil }
            fetchRequest.predicate = NSPredicate(format: "url == %@", query)
            return fetchRequest
        case .delete:
            guard let query = query as? NSData else { return nil }
            fetchRequest.predicate = NSPredicate(format: "timestamp < %@", query)
            return fetchRequest
        }
    }
}
