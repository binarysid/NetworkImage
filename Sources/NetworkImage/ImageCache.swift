import SwiftUI

final class ImageCache {
    private static let cache = NSCache<NSURL, NSData>()

    @available(macOS 10.15, *)
    static subscript(url: URL) -> Image? {
        get {
            if let data = cache.object(forKey: url as NSURL) {
                if let uiImage = NSImage(data: data as Data) {
                    return Image(nsImage: uiImage)
                }
            }
            return nil
        }
        
        set {
            if let newValue = newValue, let data = newValue.asData() {
                cache.setObject(data as NSData, forKey: url as NSURL)
            }
        }
    }
}

@available(macOS 10.15, *)
extension Image {
    func asData() -> Data? {
        return nil
    }
}
