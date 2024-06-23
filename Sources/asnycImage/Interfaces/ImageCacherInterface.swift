//
//  ImageCacherInterface.swift
//  
//
//  Created by Halit Baskurt on 22.06.2024.
//

import Foundation

public protocol ImageCacherInterface {
    func saveImage(url: String, image: Data)
    func loadImage(url: String) -> Data?
}
