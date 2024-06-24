# asyncImage Library

The library is a platform-agnostic image caching library designed to efficiently store and retrieve images using Core Data. The library supports both iOS and macOS platforms.

## Features

- Asynchronous image loading from URLs
- Caching of images to reduce network usage
- Automatic deletion of outdated cache entries
- Platform-agnostic implementation using `UIImage` on iOS and `NSImage` on macOS
- SwiftUI support with `CAsyncImage()`

## Installation

### Swift Package Manager

To integrate asyncImage into your project using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/baskurthalit/asyncImage.git", .upToNextMajor(from: "1.0.0"))
]
```
### SwiftUI Image 
Here's an example of using in SwiftUI.
  ```swift
  CAsyncImage(urlString: url) { image in
      image
          .resizable()
  } placeholder: {
      ProgressView()
  }

```

### UIImageView Extension Examples
Here's an example of extending `UIImageView` to load images using `ImageLoader` with different approaches:
### GCD
  ```swift
  extension UIImageView {
      static let imageLoader: ImageLoader = .init()
      
      func load(from imageUrl: String) {
          DispatchQueue.main.async {
              Self.imageLoader.loadImage(from: imageUrl) { result in
                  switch result {
                  case .success(let image):
                      self.image = image
                  case .failure:
                      break
                  }
              }
          }
      }
  }
```
### async/await
  ```swift
extension UIImageView {
    static let imageLoader: ImageLoader = .init()
    
    func load(from imageUrl: String) {
        Task(priority:.userInitiated) {
            image = try? await Self.imageLoader.loadImage(from: imageUrl)
        }
    }
}
```
## Requirements

- iOS 13.0 or later
- macOS 11 or later 

# Contributing

We appreciate contributions, big or small.
1. Clone the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a pull request
