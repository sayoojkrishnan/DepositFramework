//
//  NetworkLayer.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import Foundation
import Combine

protocol NetworkLayerProtocol  {
    func request<T>(type : T.Type,serviceRequest : ServiceRequest) -> AnyPublisher<T,NetworkClientError> where T: Decodable
}

final class NetworkClient : NetworkLayerProtocol {
    
    private let bgQueue = DispatchQueue(label: "NetworkLayerBackgroundQueue")
    let session : URLSessionProtocol
    init(session : URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T>(type: T.Type, serviceRequest: ServiceRequest) -> AnyPublisher<T, NetworkClientError> where T : Decodable {
        let request = URLRequest(serviceRequest: serviceRequest)
        return session.dataTask(for: request)
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkClientError.failedToConnectToHost
                }
                switch httpResponse.statusCode {
                case 200...300 :
                    return data
                case 404 :
                    throw NetworkClientError.notFound
                default:
                    throw NetworkClientError.serverError
                }
            }
            .mapError{self.mapError(error: $0)}
            .subscribe(on: bgQueue)
            .flatMap{
                Just($0).decode(type: T.self, decoder: JSONDecoder())
                    .mapError { _ in
                        return NetworkClientError.failedToParse
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    
    private func mapError(error : Error) -> NetworkClientError {
        if let networkError = error as? NetworkClientError {
            return networkError
        }else{
            let nsError = error as NSError
            switch nsError.code {
            case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet,NSURLErrorTimedOut , NSURLErrorCannotConnectToHost:
                return NetworkClientError.failedToConnectToHost
            default:
                if nsError.domain == NSURLErrorDomain {
                    return NetworkClientError.notFound
                }
                return NetworkClientError.serverError
            }
        }
    }
}

