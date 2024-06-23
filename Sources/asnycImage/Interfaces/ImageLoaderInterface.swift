//
//  ImageLoaderInterface.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//


public protocol ImageLoaderInterface {
    typealias LoadImageCompletionType = (_ result:Result<PlatformImage?,Error>) -> Void
    
    @available(macOS 12.0, *)
    @available(iOS 15.0, *)
    func loadImage(from urlString: String) async throws -> PlatformImage?
    func loadImage(from urlString: String, completion: @escaping LoadImageCompletionType)
}
