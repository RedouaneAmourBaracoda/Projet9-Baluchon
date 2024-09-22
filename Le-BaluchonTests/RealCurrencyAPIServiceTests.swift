//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class RealCurrencyAPIServiceTests: XCTestCase {

    var currencyApiService: RealCurrencyApiService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let sessionMock = URLSession(configuration: configuration)
        currencyApiService = .init(session: sessionMock)
    }

    func testNetworkCallFailsWhenInvalidURL() async throws {

        // Given.

        currencyApiService.urlString = ""

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .invalidURL)
            XCTAssert(error.errorDescription == HTTPError.invalidURL.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .invalid_base)
            XCTAssert(error.errorDescription == HTTPError.invalid_base.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .invalid_app_id)
            XCTAssert(error.errorDescription == HTTPError.invalid_app_id.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .access_restricted)
            XCTAssert(error.errorDescription == HTTPError.access_restricted.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .not_found)
            XCTAssert(error.errorDescription == HTTPError.not_found.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .not_allowed)
            XCTAssert(error.errorDescription == HTTPError.not_allowed.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: Set(-1000...1000).subtracting(Set([400, 401, 403, 404, 429])).randomElement() ?? 0,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await currencyApiService.fetchCurrency()
        } catch let error as HTTPError {
            XCTAssert(error == .invalidRequest)
            XCTAssert(error.errorDescription == HTTPError.invalidRequest.errorDescription)
        }
    }

    func testNetworkCallSuccess() async throws {

        // Given.

        let targetCurrency: CurrencyItem = .Euro

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
                    "rates": {
                        "EUR": 1.1083277687
                    }
                }
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }
        
        // Then.

        do {
            let result = try await currencyApiService.fetchCurrency()
            XCTAssertTrue(result.rates.keys.contains(where: { $0 == targetCurrency.abreviation }))
            XCTAssertTrue(result.rates.values.contains(where: { $0 == 1.1083277687 }))
        } catch {
            XCTAssertNil(error)
        }
    }
}
