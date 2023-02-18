//
//  HTTPURLResponseExtensions.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 24/12/2022.
//

import Foundation
@testable import HTTPClient

extension HTTPURLResponse {
    convenience init(url: String, statusCode: HTTPResponseStatus) {
        guard  let url = URL(string: url) else {
            fatalError("Failed to create url")
        }
        self.init(url: url, statusCode: statusCode.code, httpVersion: nil, headerFields: nil)!
    
    }
}
