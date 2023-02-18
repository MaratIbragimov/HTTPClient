//
//  HTTPResponseStatusExtensions.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 24/12/2022.
//

import Foundation
@testable import HTTPClient

extension HTTPResponseStatus {
    static var nonSuccessCodes: [HTTPResponseStatus] {
        return HTTPResponseStatus.allCases.filter { $0 != .ok }
    }
}
