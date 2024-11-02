//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class OpenExchangeAPIServiceTests: XCTestCase {

    var currencyAPIService: OpenExchangeAPIService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let sessionMock = URLSession(configuration: configuration)
        currencyAPIService = .init(session: sessionMock)
    }

    func testNetworkCallFailsWhenInvalidURL() async throws {
        currencyAPIService.urlString = ""
        try await testOpenExchangeAPIError(statusCode: Int(), testedError: .invalidURL)
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {
        try await testOpenExchangeAPIError(statusCode: 400, testedError: .invalidBase)
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {
        try await testOpenExchangeAPIError(statusCode: 401, testedError: .invalidAppId)
    }

    func testNetworkCallFailsWhenStatusCodeIs403() async throws {
        try await testOpenExchangeAPIError(statusCode: 403, testedError: .accessRestricted)
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {
        try await testOpenExchangeAPIError(statusCode: 404, testedError: .notFound)
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {
        try await testOpenExchangeAPIError(statusCode: 429, testedError: .notAllowed)
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {
        try await testOpenExchangeAPIError(
            statusCode: Set(-1000...1000).subtracting(Set([200, 400, 401, 403, 404, 429])).randomElement() ?? 0,
            testedError: .invalidRequest
        )
    }

    func testNetworkCallSuccess() async throws {

        // Given.

        let targetCurrency: CurrencyItem = .euro

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data("""
                {
                    "rates": {
                        "EUR": 1.1083277687
                    }
                }
                """.utf8)
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let rates = try await currencyAPIService.fetchCurrency()
            XCTAssertTrue(rates.keys.contains(where: { $0 == targetCurrency.identifier }))
            XCTAssertTrue(rates.values.contains(where: { $0 == 1.1083277687 }))
        } catch {
            XCTAssertNil(error)
        }
    }

    private func testOpenExchangeAPIError(statusCode: Int, testedError: OpenExchangeAPIError) async throws {

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data()
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await currencyAPIService.fetchCurrency()
        } catch let error as OpenExchangeAPIError {
            XCTAssertTrue(error == testedError)
            XCTAssertEqual(error.errorDescription, testedError.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, testedError.userFriendlyDescription)
        }
    }
}
