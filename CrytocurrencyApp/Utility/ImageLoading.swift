//
//  ImageLoading.swift
//  CrytocurrencyApp
//
//  Created by Najran Emarah on 03/05/1445 AH.
//

import SwiftUI
import UIKit



class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoaderClass

    init(url: String) {
        imageLoader = ImageLoaderClass(url: url)
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
               
                .resizable()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                
           
        } else {
            ProgressView()
        }
    }
        
}
class ImageLoaderClass: ObservableObject {
    @Published var image: UIImage?

    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.image = image
                ImageCache.shared.set(image!, forKey: self.url)
            }
        }
        task?.resume()
    }
}
