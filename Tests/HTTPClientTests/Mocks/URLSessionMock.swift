//
//  URLSessionMock.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 16/12/2022.
//

import Foundation
@testable import HTTPClient

typealias URLSessionResponseTuple = (data: Data, urlResponse: URLResponse)
class URLSessionMock {
    private var data: Data?
    private var error: Error?
    public var recordedRequest: URLRequest?
    
    private let result:  Result<URLSessionResponseTuple, Error>
    init(result: Result<URLSessionResponseTuple, Error>) {
        self.result = result
    }

}

extension URLSessionMock: SessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        recordedRequest = request
        switch result {
        case let .failure(error):
            throw error
        case .success(let responseTuple):
            if let urlResponse = responseTuple.urlResponse as? HTTPURLResponse {
                switch urlResponse.status {
                case .ok:
                    return responseTuple
                default:
                    return (Data(), urlResponse)
                }
            } else {
                return responseTuple
            }
        }
    
    }
}
