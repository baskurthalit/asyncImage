//
//  ImageCacheStorageInterface.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import Foundation

public protocol ImageCacheStorageInterface {
    func loadImage(url: String) -> Data?
    func saveImage(url: String, imageData: Data?)
    func addNewEntity(imageData: Data?, for url: String, timestamp: Date?)
    
    func imageEntity(for url: String) -> ImageEntity?
    func deleteEntities(olderThan time: TimeInterval)
}
