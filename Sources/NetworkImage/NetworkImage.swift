import SwiftUI

struct NetworkImage<Content: View>: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(url: URL, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cachedImage = ImageCache[url] {
            content(.success(cachedImage))
        } else {
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cachAndRenderView(by: phase)
            }
        }
    }
}

extension NetworkImage {
    private func cachAndRenderView(by phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}
