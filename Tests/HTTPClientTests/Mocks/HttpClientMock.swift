//
//  HttpClientMock.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 17/12/2022.
//

import Foundation
@testable import HTTPClient

typealias ResponseTuple = (data: Data, urlResponse: HTTPURLResponse)

class HttpClientMock: HTTPClientProtocol {
    
    private let expectedResult: Result<ResponseTuple, Error>
    var recordedRequest: HTTPRequest?
    init(expectedResult: Result<ResponseTuple, Error>) {
        self.expectedResult = expectedResult
    }

    
    func data(for request: HTTPRequest) async throws -> HTTPResponse {
        recordedRequest = request
        
        switch expectedResult {
        case .failure(let error):
            throw error
        case .success(let responseTuple):
            return HTTPResponse(status: responseTuple.urlResponse.status,
                                data: responseTuple.data)
        }
    }
    
}
