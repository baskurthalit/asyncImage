//
//  ImageLoader.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import Foundation

/**
 `ImageLoader` is a structure used to handle images loaded from remote sources. It provides functionality for caching images and storing them locally for offline use.
 
 The core functionalities of `ImageLoader` include loading an image from a URL and caching it, retrieving an image from the cache, and saving an image to the local cache.
 */
public struct ImageLoader: ImageLoaderInterface {
    public static let instance: ImageLoaderInterface = ImageLoader()
    /// An instance of `ImageCacherInterface` responsible for caching and retrieving images.
    let imageCacher: ImageCacherInterface
    
    /**
     Initializes the structure with an optional `ImageCacherInterface` instance.
     
     - Parameter imageCacher: An optional `ImageCacherInterface` instance. If not provided, a default `ImageCacher` instance will be used.
     */
    public init(imageCacher: ImageCacherInterface? = nil) {
        self.imageCacher = imageCacher ?? ImageCacher()
    }
    
    /**
     Loads an image from the specified URL asynchronously.
     
     - Parameters:
        - urlString: The URL string from which to load the image.
     
     - Returns: A `UIImage` object representing the loaded image, or `nil` if the image couldn't be loaded.
     */
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    public func loadImage(from urlString: String) async throws -> PlatformImage? {
        guard !urlString.isEmpty else { return nil }
        
        if let imageData = imageCacher.loadImage(url: urlString),
           let image = PlatformImage(data: imageData) {
            return image
        } else {
            guard let url = URL(string: urlString) else { return nil }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image: PlatformImage = .init(data: data) else { return nil }
            imageCacher.saveImage(url: urlString, image: data)
            return image
        }
        
    }
    
    /**
     Loads an image from the specified URL asynchronously.
     
     - Parameters:
        - urlString: The URL string from which to load the image.
     
     - Returns: A `UIImage` object representing the loaded image, or `nil` if the image couldn't be loaded.
     */
    public func loadImage(from urlString: String, completion: @escaping LoadImageCompletionType) {
        guard !urlString.isEmpty else { return completion(.failure(NSError())) }
        
        if let imageData = imageCacher.loadImage(url: urlString),
           let image = PlatformImage(data: imageData) {
            return completion(.success(image))
        } else {
            guard let url = URL(string: urlString) else { return completion(.failure(NSError())) }
            URLSession.shared.dataTask(with: url) { imageData, urlResponse, error in
                guard let imageData, error == nil
                else {
                    completion(.failure(NSError()))
                    return
                }
                
                completion(.success(.init(data: imageData)))
                
                imageCacher.saveImage(url: urlString, image: imageData)
                
            }.resume()
        }
    }
}
