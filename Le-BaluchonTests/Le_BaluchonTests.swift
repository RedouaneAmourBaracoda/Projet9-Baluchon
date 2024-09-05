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
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        apiService = .init(session: session)
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

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
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .invalidAuthenticationCredentials)
            XCTAssert(error.errorDescription == HTTPError.invalidAuthenticationCredentials.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs403() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

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
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .invalidTrial)
            XCTAssert(error.errorDescription == HTTPError.invalidTrial.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

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
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .invalidEndpoint)
            XCTAssert(error.errorDescription == HTTPError.invalidEndpoint.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs422() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 422,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .validationError)
            XCTAssert(error.errorDescription == HTTPError.validationError.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

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
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .exceededRequestsLimit)
            XCTAssert(error.errorDescription == HTTPError.exceededRequestsLimit.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs500() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .internalServorError)
            XCTAssert(error.errorDescription == HTTPError.internalServorError.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 1000,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
        } catch let error as HTTPError {
            XCTAssert(error == .invalidRequest)
            XCTAssert(error.errorDescription == HTTPError.invalidRequest.errorDescription)
        }
    }

    func testNetworkCallSuccess() async {

        // Given.

        let baseCurrency: CurrencyItem = .USDollar
        let convertToCurrency: CurrencyItem = .Euro

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
                        "EUR": 1.1083277687
                    }
                }
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }
        
        // Then.
        do {
            let result = try await apiService.fetchCurrency(baseCurrency: baseCurrency.abreviation, convertToCurrency: convertToCurrency.abreviation)
            XCTAssertTrue(result.data.keys.contains(where: { $0 == convertToCurrency.abreviation }))
            XCTAssertTrue(result.data.values.contains(where: { $0 == 1.1083277687 }))
        } catch {
            XCTAssertNil(error)
        }
    }
}
