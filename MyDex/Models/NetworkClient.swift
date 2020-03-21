//
//  NetworkClient.swift
//  MRTToolbox
//
//  Created by Michael Thomas on 11/9/18.
//  Copyright © 2018 Michael Thomas. All rights reserved.
//

import Foundation
import Combine

public class NetworkClient {
    public static let shared = NetworkClient()
    
    private let session = URLSession(configuration: .ephemeral)
    private let decodeQueue = DispatchQueue.init(label: "NetworkClient.Decode.Queue", qos: .userInitiated)
    
    private init() { }
    
    public func performCodableRequest<ModelType: Codable>(_ urlRequest: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<ModelType, Swift.Error> {
        performDataRequest(urlRequest)
            .receive(on: decodeQueue)
            .decode(type: ModelType.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func performDataRequest(_ urlRequest: URLRequest) -> AnyPublisher<Data, Swift.Error> {
        session.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                if let httpURLResponse = response as? HTTPURLResponse,
                    !(200...300).contains(httpURLResponse.statusCode) {
                    throw Error.badResponseCode(httpURLResponse.statusCode)
                }
                return data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public enum Error: Swift.Error {
        case badResponseCode(Int)
        case malformedURL
    }
}
