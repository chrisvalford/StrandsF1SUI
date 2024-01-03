//
//  Cache.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 6/9/23.
//

import Foundation
import CoreData

class Cache {

    fileprivate static var context: NSManagedObjectContext = {
        PersistenceController.shared.container.viewContext
    }()

    class func update(url: URL, data: Data) async throws {
        let fetchRequest: NSFetchRequest<CacheItem>
        fetchRequest = CacheItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        do {
            let cacheItems = try context.fetch(fetchRequest)
            if cacheItems.count > 0 {   // Update url, data values if they exist
                let cacheItem = cacheItems.first!
                cacheItem.created = Date()
                cacheItem.data = data
                try context.save()
            } else {                    // Otherwise crate a new entry
                let cacheItem = CacheItem(context: context)
                cacheItem.url = url
                cacheItem.created = Date()
                cacheItem.data = data
                try context.save()
            }
        } catch {
            throw APIError.cacheError
        }
    }

    class func read(url: URL) throws -> Data? {
        let fetchRequest: NSFetchRequest<CacheItem>
        fetchRequest = CacheItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        do {
            let cacheItems = try context.fetch(fetchRequest)
            if cacheItems.count > 0 {
                guard let first = cacheItems.first else {
                    throw APIError.cacheError
                }
                return first.data
            } else {
                throw APIError.cacheEmpty
            }
        } catch {
            throw APIError.cacheError
        }
    }
}
