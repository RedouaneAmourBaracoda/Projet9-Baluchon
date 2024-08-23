//
//  CurrencyAPIServiceTests.swift
//  Le-BaluchonTests
//
//  Created by Damien Rivet on 23/08/2024.
//

@testable import Le_Baluchon
import XCTest

final class RemoteCurrencyAPIServiceTests: XCTestCase {

    // MARK: - Properties

    var session: URLSession!
    var apiService: RemoteCurrencyAPIService!

    // MARK: - Functions

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        session = URLSession(configuration: configuration)
        
        apiService = RemoteCurrencyAPIService(urlSession: session)
    }

    // MARK: - Tests

    func testNetworkCallSuccess() async throws {
        // When
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

        // Then
        let result = try await apiService.fetchCurrency(baseCurrency: "EUR", convertToCurrency: "USD")
        XCTAssert(result.data.count == 5)
    }
}
