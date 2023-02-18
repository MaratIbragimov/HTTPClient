//
//  HttpClient.swift
//  SpotifyApiExample
//
//  Created by Marat Ibragimov on 24/12/2022.
//

#if canImport(Foundation)


import Foundation

protocol HTTPClientProtocol {
    func data(for request: HTTPRequest) async throws -> HTTPResponse
}

protocol SessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}


struct HostURL: RawRepresentable {
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension URLSession: SessionProtocol {}

struct HTTPRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    var host: String
    var path: String
    var httpMethod: HTTPMethod
    var query: [String: String]? = nil
    var data: Data? = nil
}

struct HTTPResponse {
    let status: HTTPResponseStatus
    let data: Data
}

class HTTPClient: HTTPClientProtocol {
    
    private let session: SessionProtocol
    init(session: SessionProtocol) {
        self.session = session
    }
    
    func data(for request: HTTPRequest) async throws -> HTTPResponse {
        let url = try URLBuilder()
                        .set(host: request.host)
                        .set(path: request.path)
                        .set(scheme: .https)
                        .build()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.data
        let (data, response) = try await session.data(for: urlRequest,
                                                      delegate: nil)
        guard let urlHttpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return HTTPResponse(status: urlHttpResponse.status,
                            data: data)
    }

}

#endif
