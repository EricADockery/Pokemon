//
//  NetworkClient.swift
//  MyDex
//
//  Created by Eric Dockery on 3/21/20.
//  Copyright © 2020 Eric Dockery. All rights reserved.
//

import Foundation
import Combine

enum NetworkError: Error {
      case badResponseCode(Int)
      case malformedURL
  }

final class NetworkClient {
    static let shared = NetworkClient()
    
    private let session = URLSession(configuration: .ephemeral)
    private let decodeQueue = DispatchQueue.init(label: "NetworkClient.Decode.Queue", qos: .userInitiated)
    
    private init() { }
    
    func performCodableRequest<ModelType: Codable>(_ urlRequest: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<ModelType, Error> {
        performDataRequest(urlRequest)
            .receive(on: decodeQueue)
            .decode(type: ModelType.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func performDataRequest(_ urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                if let httpURLResponse = response as? HTTPURLResponse,
                    !(200...300).contains(httpURLResponse.statusCode) {
                    throw NetworkError.badResponseCode(httpURLResponse.statusCode)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
