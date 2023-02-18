import XCTest
@testable import HTTPClient

final class HttpClientTests: XCTestCase {
    
    private let urlResponse = URLResponse()
    private let responseData = ["key1":"some_data"].toJSONData()
    private let requestData = ["key2":"some_data"].toJSONData()
    private let path = "/v1/album"
    private let host = "example.api.com"
    lazy var url = host + path
    
    
    func testGetSuccess() async throws {
        
        let responseTuple = URLSessionResponseTuple(data: responseData,
                                                    urlResponse: HTTPURLResponse.init(url: url,
                                                                                   statusCode: .ok))
        let response = try await testRequest(httpMethod: .get,
                                             path: path,
                                             expectedResult: .success(responseTuple))
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.data, responseData)
    }
    
    func testPostSuccess() async throws {
        
        let responseTuple = URLSessionResponseTuple(data: responseData,
                                                    urlResponse: HTTPURLResponse.init(url: url,
                                                                                   statusCode: .ok))
        let response = try await testRequest(httpMethod: .post,
                                             path: path,
                                             requestBody: requestData,
                                             expectedResult: .success(responseTuple))
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.data, responseData)
    }
    
    func testPutSuccess() async throws {
        let responseTuple = URLSessionResponseTuple(data: responseData,
                                                    urlResponse: HTTPURLResponse.init(url: url,
                                                                                   statusCode: .ok))
        let response = try await testRequest(httpMethod: .put,
                                             path: path,
                                             requestBody: requestData,
                                             expectedResult: .success(responseTuple))
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.data, responseData)
    }
    
    func testSuccess() async throws {
        let responseTuple = URLSessionResponseTuple(data: responseData,
                                                    urlResponse: HTTPURLResponse.init(url: url,
                                                                                   statusCode: .ok))
        
        let response = try await testRequest(httpMethod: .delete,
                                             path: path,
                                             requestBody: requestData,
                                             expectedResult: .success(responseTuple))
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.data, responseData)
        
    }
    
    
    func testBadResponse() async throws {
        let responseTuple = URLSessionResponseTuple(data: responseData,
                                                    urlResponse: URLResponse())
        var caughtError: URLError?
        do {
            try await testRequest(httpMethod: .get,
                                  path: path,
                                  requestBody: requestData,
                                  expectedResult: .success(responseTuple))
        } catch {
            caughtError = error as? URLError
        }
        
        XCTAssertEqual(caughtError, .init(.badServerResponse))
    }
    
    
    func testURLErrors() async {
        let urlErrors = URLError.errorCodes()
        for urlError in urlErrors {
            var caughtError: URLError?
            do {
                try await testRequest(httpMethod: .get,
                                      path: path,
                                      expectedResult: .failure(urlError))
            } catch {
                caughtError = error as? URLError
            }
            
            XCTAssertEqual(caughtError, urlError)
        }
    }
    
    func testGetHttpErrorStatusCodes() async throws {
        
        let httpErrorCodes = HTTPResponseStatus.allCases.filter { $0 != .ok }
        
        for errorCode in httpErrorCodes {
            let httpErrorCodeTuple: URLSessionResponseTuple = (data: responseData, urlResponse:
                                                                HTTPURLResponse(url: url, statusCode: errorCode))
            
            
            let response =  try await testRequest(httpMethod: .get,
                                                  path: path,
                                                  requestBody: requestData,
                                                  expectedResult: .success(httpErrorCodeTuple))
            
            XCTAssertTrue(response.data.isEmpty)
            XCTAssertEqual(response.status, errorCode)
        }
        
    }
    
    
    @discardableResult
    func testRequest(httpMethod: HTTPRequest.HTTPMethod,
                     path: String,
                     requestBody: Data? = nil,
                     expectedResult: Result<URLSessionResponseTuple, Error>)  async throws -> HTTPResponse {
        
        
        let (response, request) =  try await sendMockedRequest(httpMethod: httpMethod,
                                                               host: host,
                                                               path: path,
                                                               body: requestBody,
                                                               expectedResult: expectedResult)
        
        XCTAssertEqual(request?.httpMethod, httpMethod.rawValue)
        XCTAssertEqual(request?.httpBody, requestBody)
        XCTAssertEqual(request?.url?.absoluteString, "https://\(host)\(path)")
        
        return response
    }
    
    
    func testRequestFailure(error: Error,
                            httpMethod: HTTPRequest.HTTPMethod,
                            path: String,
                            requestBody: Data? = nil) async throws {
        
        let urlSession =  URLSessionMock(result: .failure(error))
        let httpClient = HTTPClient(session: urlSession)
        let httpRequest = HTTPRequest(host: host,
                                      path: path,
                                      httpMethod: httpMethod,
                                      data: requestBody)
        let _ = try await  httpClient.data(for: httpRequest)
    }
    
    @discardableResult
    func sendMockedRequest(httpMethod: HTTPRequest.HTTPMethod,
                           host: String,
                           path: String,
                           body: Data?,
                           expectedResult: Result<URLSessionResponseTuple, Error>) async throws -> (HTTPResponse, URLRequest?) {
        let urlSession = URLSessionMock(result: expectedResult)
        let httpClient = HTTPClient(session: urlSession)
        let httpRequest = HTTPRequest(host: host,
                                      path: path,
                                      httpMethod: httpMethod,
                                      data: body)
         let response = try await httpClient.data(for: httpRequest)
        let urlRequest =  urlSession.recordedRequest
        return (response, urlRequest)
    }
}
