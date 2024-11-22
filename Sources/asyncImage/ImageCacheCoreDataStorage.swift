//
//  ImageCacheCoreDataManager.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import CoreData

/**
 `ImageCacheCoreDataStorage` is a class responsible for managing image caching using Core Data as the storage mechanism. It conforms to the `ImageCacheStorageInterface` protocol.
 
 You can use `ImageCacheCoreDataStorage` to save, load, and delete images from the Core Data cache.
 */
class ImageCacheCoreDataStorage: ImageCacheStorageInterface {
    static let shared: ImageCacheCoreDataStorage? = try? .init()
    /// The name of the Core Data model.
    class func modelName() -> String { "ImageCacheModel" }
    
    /// Retrieves the managed object model associated with the Core Data model.
    class func model() -> NSManagedObjectModel? { NSManagedObjectModel.with(name: modelName(), in: .module) }
    
    /// The persistent container used for managing the Core Data stack.
    let persistentContainer: NSPersistentContainer
    
    /// The managed object context associated with the persistent container.
    public let context: NSManagedObjectContext
    
    /// An enumeration representing possible errors that can occur during storage operations.
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    /// An enumeration representing the type of managed object context queue.
    public enum ContextQueue {
        case main
        case background
    }
    
    /**
     Initializes the `ImageCacheCoreDataStorage` with the specified parameters.
     
     - Parameters:
        - storeURL: The URL where the Core Data store file is located.
        - contextQueue: The type of managed object context queue to be used.
     - Throws: An error of type `StoreError` if the model cannot be found or if the persistent container fails to load.
     */
    private init(storeURL: URL = NSPersistentContainer.defaultDirectoryURL().appendingPathExtension("image-cache.sqlite"),
                contextQueue: ContextQueue = .background) throws {
        guard let model = ImageCacheCoreDataStorage.model() else {
            throw StoreError.modelNotFound
        }
        
        do {
            persistentContainer = try NSPersistentContainer.load(name: ImageCacheCoreDataStorage.modelName(), model: model, url: storeURL)
            context = contextQueue == .main ? persistentContainer.viewContext : persistentContainer.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    /**
     Loads the image data associated with the specified URL asynchronously.
     
     - Parameter url: The URL associated with the image data to be loaded.
     - Returns: An optional `Data` object representing the loaded image data, or `nil` if the image data couldn't be loaded.
     */
    func loadImage(url: String) -> Data? {
        self.imageEntity(for: url)?.imageData
    }
    
    /**
     Saves the image data for the specified URL.
     
     - Parameters:
        - url: The URL associated with the image data.
        - imageData: The image data to be saved.
     */
    func saveImage(url: String, imageData: Data?) {
        guard let imageData else { return }
        
        context.perform {
            let result = self.imageEntity(for: url)
            if result == nil {
                self.addNewEntity(imageData: imageData, for: url)
            } else {
                self.updateExistingEntity(result, imageData: imageData)
            }
        }
    }
    
    func imageEntity(for url: String) -> ImageEntity? {
        guard let request = CacheFetchRequestType.find.nsRequest(for: url) else { return nil }
        return filterImages(for: request)?.first
    }
    
    /**
     Deletes entities that are older than the specified time interval from the cache.
     - Parameter time: The time interval (in seconds) used to determine the age of entities to be deleted.
     */
    func deleteEntities(olderThan time: TimeInterval) {
        let timeBuffer = Date().addingTimeInterval(-time)
        context.perform {
            guard let request = CacheFetchRequestType.delete.nsRequest(for: timeBuffer) else { return }
            let results = self.filterImages(for: request)
            results?.forEach{ self.context.delete($0)}
            self.saveContext()
        }
        
    }
    
    private func saveContext() {
        context.perform {
            do { try self.context.save() }
            catch { debugPrint("Save Contex fail with: \(error.localizedDescription), on \(self)") }
        }
    }
}

//MARK: Helper Methods
extension ImageCacheCoreDataStorage {
    func addNewEntity(imageData: Data?, for url: String, timestamp: Date? = .init()) {
        guard let imageData else { return }
        let newImageEntity = ImageEntity(context: context)
        newImageEntity.url = url
        newImageEntity.imageData = imageData
        newImageEntity.timestamp = timestamp
        saveContext()
    }
    
    func updateExistingEntity(_ imageEntity: ImageEntity?, imageData: Data?) {
        imageEntity?.imageData = imageData
        imageEntity?.timestamp = Date()
        saveContext()
    }
    
    private func filterImages(for fetchRequest: NSFetchRequest<ImageEntity>) -> [ImageEntity]? {
        guard let results = try? context.fetch(fetchRequest) else { return nil }
        return results
    }
}
