//
//  ImageLoader.swift
//  MyDex
//
//  Created by Eric Dockery on 3/30/21.
//  Copyright © 2021 Eric Dockery. All rights reserved.
//

import UIKit

protocol ImageLoadFailed {
    func handleImageLoadFailing(_ error: Error)
}

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    private var uuidMap = [UIImageView: UUID]()
    static let shared = ImageLoader()
    private init() { }
    
    var imageLoadFailureDelegate: ImageLoadFailed?
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {self.runningRequests.removeValue(forKey: uuid) }
            if let data = data,
               let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else {
                return
            }
            
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            
        }
        task.resume()
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
    
    func load(_ url: URL, for imageView: UIImageView) {
      let token = self.loadImage(url) { result in
        defer { self.uuidMap.removeValue(forKey: imageView) }
        
        switch result {
        case .success(let image):
            DispatchQueue.main.async {
                imageView.image = image
            }
        case .failure(let error):
            self.imageLoadFailureDelegate?.handleImageLoadFailing(error)
        }
       
      }

      if let token = token {
        uuidMap[imageView] = token
      }
    }
    
    func cancel(for imageView: UIImageView) {
      if let uuid = uuidMap[imageView] {
        self.cancelLoad(uuid)
        uuidMap.removeValue(forKey: imageView)
      }
    }
}
