import SwiftUI

public struct NetworkImage<Content: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    public init(url: URL?, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {
        if let url = url {
            if let cachedImage = ImageCache[url] {
                content(.success(cachedImage))
            } else {
                AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                    cachAndRenderView(by: phase, url: url)
                }
            }
        } else {
            Image(systemName: "questionmark")
        }
    }
}

extension NetworkImage {
    private func cachAndRenderView(by phase: AsyncImagePhase, url: URL) -> some View {
        if case .success(let image) = phase {
            // Cache the image when it's successfully loaded
            if let _ = image.asData() {
                ImageCache[url] = image
            }
        }
        return content(phase)
    }
}
