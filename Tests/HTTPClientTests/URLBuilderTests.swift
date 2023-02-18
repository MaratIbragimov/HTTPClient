//
//  URLBuilderTests.swift
//  SpotifyApiExampleTests
//
//  Created by Marat Ibragimov on 11/12/2022.
//

import XCTest
@testable import HTTPClient

final class URLBuilderTests: XCTestCase {

    let host = HostURL.init(rawValue: "google.com")
    
    func testBuildURL() throws {
        
        let url = try URLBuilder()
                        .set(scheme: .https)
                        .set(host: host.rawValue)
                        .set(path: "/v1/album")
                        .build()
        XCTAssertEqual(url.absoluteString, "https://\(host.rawValue)/v1/album")
    }
    
    
    func testBuildURLWithQueryParams() throws {
        
        let url = try URLBuilder()
                        .set(scheme: .https)
                        .set(host: host.rawValue)
                        .set(path: "/v1/album")
                        .set(query: ["key": "value"])
                        .build()
    
        XCTAssertEqual(url.absoluteString, "https://\(host.rawValue)/v1/album?key=value")
    }
    
    func testBuildURLWithPort() throws {
        
        let url = try URLBuilder()
                        .set(scheme: .https)
                        .set(port: 8080)
                        .set(host: host.rawValue)
                        .set(path: "/v1/album")
                        .set(query: ["key": "value"])
                        .build()
    
        XCTAssertEqual(url.absoluteString, "https://\(host.rawValue):8080/v1/album?key=value")
    }
    
    func testBuildURLWithURLEncodedQueryParams() throws {

        let url = try URLBuilder()
            .set(scheme: .https)
            .set(host: host.rawValue)
            .set(path: "/v1/album")
            .set(query: ["key": "this is a text"])
            .build()
    
        XCTAssertEqual(url.absoluteString, "https://\(host.rawValue)/v1/album?key=this%20is%20a%20text")
    }
    
    func testEmptyHost() {
        let urlBuilder = URLBuilder()
                         .set(scheme: .https)
                         .set(path: "/v1/album")
                                   

        XCTAssertThrowsError(try urlBuilder.build()) { error in
            XCTAssertEqual(error as? URLBuilderError, .emptyHost)
        }
    }
    
    func testEmptyPath() {
        let urlBuilder = URLBuilder()
                         .set(scheme: .https)
                         .set(host: "host")

        XCTAssertThrowsError(try urlBuilder.build()) { error in
            XCTAssertEqual(error as? URLBuilderError, .emptyPath)
        }
    }
}
