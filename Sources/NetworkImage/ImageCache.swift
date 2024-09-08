import SwiftUI

final class ImageCache {
    // NSCache to hold image data
    private static let cache = NSCache<NSURL, NSData>()

    @available(macOS 10.15, *)
    static subscript(url: URL) -> Image? {
        get {
            // Retrieve image data from cache
            if let data = cache.object(forKey: url as NSURL) {
                // Convert Data to Image using SwiftUI's Image initializer
                if let uiImage = NSImage(data: data as Data) {  // Use NSImage for cross-platform
                    return Image(nsImage: uiImage)
                }
            }
            return nil
        }
        set {
            // Cache the image data
            if let newValue = newValue, let data = newValue.asData() {
                cache.setObject(data as NSData, forKey: url as NSURL)
            }
        }
    }
}

@available(macOS 10.15, *)
extension Image {
    // Convert SwiftUI Image to Data (this is more complex and may not be straightforward)
    func asData() -> Data? {
        // SwiftUI does not provide direct conversion from Image to Data.
        // This is a placeholder function. You might need to handle the actual conversion based on your source.
        return nil
    }
}
