//
//  CAsyncImage.swift
//
//
//  Created by Halit Baskurt on 23.06.2024.
//

import SwiftUI

@available(iOS 13.0, *)
public struct CAsyncImage<C: View,P: View>: View {
    @State var image: Image?
    
    var content: (Image) -> C
    var placeholder: () -> P
    let urlString: String
    
    public init(urlString: String,
                @ViewBuilder content: @escaping (Image) -> C,
                @ViewBuilder placeholder: @escaping () -> P) {
        self.urlString = urlString
        self.content = content
        self.placeholder = placeholder
        
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            ImageView
                .task { loadImage(from: urlString) }
        } else {
            ImageView
                .onAppear { loadImage(from: urlString) }
        }
    }
    
    private var ImageView: some View {
        ZStack {
            if let image = image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
    
    private func loadImage(from urlString: String) {
        ImageLoader.instance.loadImage(from: urlString) { result in
            switch result {
            case .success(let image):
                guard let image else { return }
                DispatchQueue.main.async { self.image = .init(uiImage: image) }
            default: break
            }
        }
    }
}
