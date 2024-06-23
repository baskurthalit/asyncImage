//
//  ImageCacher.swift
//
//
//  Created by Halit Baskurt on 22.06.2024.
//

import Foundation
/**
 `ImageCacher` is a class responsible for caching and retrieving images using a storage mechanism provided by an object conforming to `ImageCacheStorageInterface`.
 
 You can use `ImageCacher` to save images to a cache and retrieve them later. It also handles the deletion of outdated image entities based on a predefined time interval.
 */
final class ImageCacher: ImageCacherInterface {
    
    private let storage: ImageCacheStorageInterface?
    
    /**
     Initializes an `ImageCacher` with the specified storage mechanism.
     
     - Parameter coreData: An optional object conforming to `ImageCacheStorageInterface`. If not provided, a default `ImageCacheCoreDataStorage` instance will be used.
     */
    init(coreData: ImageCacheStorageInterface? = ImageCacheCoreDataStorage.shared) {
        self.storage = coreData
    }
    
    /**
     Saves the given image to the cache for the specified URL.
     
     - Parameters:
        - url: The URL associated with the image.
        - image: The image to be saved to the cache.
     */
    public func saveImage(url: String, image imageData: Data) {
        storage?.saveImage(url: url, imageData: imageData)
        deleteOutdatedEntities()
    }
    
    /**
     Loads an image from the cache for the specified URL asynchronously.
     
     - Parameter url: The URL associated with the image to be loaded.
     - Returns: An optional `UIImage` object representing the loaded image, or `nil` if the image couldn't be loaded.
     */
    public func loadImage(url: String) -> Data? {
        guard let imageData = storage?.loadImage(url: url) else { return nil }
        return imageData
    }
    
    /**
     Deletes outdated image entities from the cache based on a predefined time interval.
     */
    private func deleteOutdatedEntities() {
        storage?.deleteEntities(olderThan: .sevenDays)
    }
}
