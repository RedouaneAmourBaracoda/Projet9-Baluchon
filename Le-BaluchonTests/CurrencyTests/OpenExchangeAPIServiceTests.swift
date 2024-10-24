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

        // Given.

        currencyAPIService.urlString = ""

        // Then.

        do {
            _ = try await currencyAPIService.fetchCurrency()
        } catch let error as OpenExchangeAPIError {
            XCTAssert(error == .invalidURL)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.invalidURL.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 400,
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
            XCTAssert(error == .invalidBase)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.invalidBase.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 401,
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
            XCTAssert(error == .invalidAppId)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.invalidAppId.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs403() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 403,
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
            XCTAssert(error == .accessRestricted)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.accessRestricted.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
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
            XCTAssert(error == .notFound)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.notFound.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 429,
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
            XCTAssert(error == .notAllowed)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.notAllowed.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: Set(-1000...1000).subtracting(Set([200, 400, 401, 403, 404, 429])).randomElement() ?? 0,
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
            XCTAssert(error == .invalidRequest)
            XCTAssert(error.errorDescription == OpenExchangeAPIError.invalidRequest.errorDescription)
        }
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
}
