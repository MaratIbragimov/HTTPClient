//
//  DictionaryExtensions.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 24/12/2022.
//

import Foundation


extension Dictionary {
    func toJSONData() -> Data {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else {
            fatalError("couldn't parse \(self) to json")
        }
        return data
    }
}
