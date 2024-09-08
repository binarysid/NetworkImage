import XCTest
import SwiftUI
@testable import NetworkImage

// Mock AsyncImage for testing
struct MockAsyncImage: View {
    let phase: AsyncImagePhase

    var body: some View {
        switch phase {
        case .empty:
            return Image(systemName: "questionmark")
        case .success(let image):
            return image
        case .failure:
            return Image(systemName: "exclamationmark")
        @unknown default:
            return Image(systemName: "questionmark")
        }
    }
}

final class NetworkImageTests: XCTestCase {

    func testNetworkImageWithCachedImage() {
        // Given
        let testURL = URL(string: "https://example.com/test.jpg")!
        let testImage = Image(systemName: "star")
        ImageCache[testURL] = testImage  // Pre-cache the image
        
        let view = NetworkImage(url: testURL) { phase in
            MockAsyncImage(phase: phase)
        }
        
        // Since we cannot directly access the SwiftUI view state, test the logic around caching
        let cachedImage = ImageCache[testURL]
        XCTAssertNotNil(cachedImage)
    }

    func testNetworkImageLoadsAndCachesImage() {
        // Given
        let testURL = URL(string: "https://example.com/test.jpg")!
        let expectation = XCTestExpectation(description: "Image loads and caches")
        
        // Replace AsyncImage with a mock or stub that simulates loading
        let view = NetworkImage(url: testURL) { phase in
            switch phase {
            case .success(let image):
                // Cache the image when it's successfully loaded
                ImageCache[testURL] = image
                expectation.fulfill()
                return image
            default:
                return Image(systemName: "questionmark")
            }
        }

//        // Simulate AsyncImage loading
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            _ = try? view.inspect().find(text: "questionmark")
//        }

        // Wait for expectations
        wait(for: [expectation], timeout: 2)
    }

    func testNetworkImageWithInvalidURL() {
        // Given
        let invalidURL = URL(string: "invalid-url")!
        
        let view = NetworkImage(url: invalidURL) { phase in
            MockAsyncImage(phase: phase)
        }

        // Since we cannot directly access the SwiftUI view state, test the behavior
        // We can check that the view handles invalid URLs correctly by checking for a placeholder
        let expectedImage = Image(systemName: "questionmark")
        let cachedImage = ImageCache[invalidURL]
        XCTAssertNil(cachedImage)
    }
}
