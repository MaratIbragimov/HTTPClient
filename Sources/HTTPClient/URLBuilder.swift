//
//  URLBuilder.swift
//  SpotifyApiExample
//
//  Created by Marat Ibragimov on 10/01/2023.
//

import Foundation

enum URLScheme: String {
    case http
    case https
}

enum URLBuilderError: Error {
    case emptyHost
    case emptyPath
    case failedToBuildURL
}

class URLBuilder {
    private var host: String?
    private var path: String?
    private var query: [String: String]?
    private var port: Int?
    private var scheme: URLScheme = .https
   
    func build() throws -> URL {
    
        guard let host else {
            throw URLBuilderError.emptyHost
        }
        
        guard let path else {
            throw URLBuilderError.emptyPath
        }
        
        
        var components = URLComponents()
        components.path = path
        components.host = host
        components.scheme = scheme.rawValue
        components.port = port
        components.queryItems = query?.map{ key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let constructedURL =  components.url else {
            throw URLBuilderError.failedToBuildURL
        }
        
        return constructedURL
    }
    
    func set(host: String) -> Self {
        self.host = host
        return self
    }
    
    func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    func set(scheme: URLScheme) -> Self {
        self.scheme = scheme
        return self 
    }
    
    func set(port: Int) -> Self {
        self.port = port
        return self
    }
    
    func set(query: [String: String]) -> Self {
        self.query = query
        return self
    }
}
