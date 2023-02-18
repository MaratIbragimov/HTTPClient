//
//  JSONSerializationExtensions.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 17/12/2022.
//

import Foundation


extension JSONSerialization {
    static func makeRequestBody(dictionary: [String: Any]) throws -> Data {
        try JSONSerialization.data(withJSONObject:dictionary)
    }
}
