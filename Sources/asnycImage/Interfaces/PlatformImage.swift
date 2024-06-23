//
//  PlatformImage.swift
//  
//
//  Created by Halit Baskurt on 23.06.2024.
//

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

protocol PlatformImageType {
    init?(data: Data)
    func pngData() -> Data?
}

#if canImport(AppKit)
extension NSImage: PlatformImageType {
    func pngData() -> Data? {
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        return bitmap.representation(using: .png, properties: [:])
    }
}
#endif
