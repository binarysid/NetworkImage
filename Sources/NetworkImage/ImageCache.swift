//
//  ImageCache.swift
//  
//
//  Created by Linkon Sid on 2/9/23.
//

import SwiftUI

final class ImageCache {
    private static var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            cache[url]
        }
        set {
            cache[url] = newValue
        }
    }
}
