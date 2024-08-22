//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class Le_BaluchonTests: XCTestCase {
    var session: URLSession!
    var apiService: CurrencyApiService!
    
    override func setUpWithError() throws {
        
        // Given.
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        apiService = .init(session: session)
    }
    
    func testNetworkCallSuccess() async throws {
        
        // When.
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            let mockData = """
                {
                  "data": {
                    "CAD": 1.358280156,
                    "EUR": 0.8961501169,
                    "GBP": 0.7639101497,
                    "JPY": 145.1090657484,
                    "USD": 1,
                  }
                }
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }
        
        // Then.
        
        let result = try await apiService.fetchCurrency()
        XCTAssert(result.data.count == 5)
    }
}
