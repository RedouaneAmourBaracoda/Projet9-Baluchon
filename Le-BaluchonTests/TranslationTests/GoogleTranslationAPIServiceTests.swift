//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class GoogleTranslationAPIServiceTests: XCTestCase {

    var translationAPIService: GoogleTranslationAPIService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let sessionMock = URLSession(configuration: configuration)
        translationAPIService = .init(session: sessionMock)
    }

    func testNetworkCallFailsWhenInvalidURL() async throws {

        // Given.

        translationAPIService.urlString = ""

        // Then.

        do {
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .invalidURL)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.invalidURL.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, GoogleTranslationAPIError.invalidURL.userFriendlyDescription)
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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .badRequest)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.badRequest.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, GoogleTranslationAPIError.badRequest.userFriendlyDescription)
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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssert(error == .unauthorized)
            XCTAssert(error.errorDescription == GoogleTranslationAPIError.unauthorized.errorDescription)
            XCTAssert(error.userFriendlyDescription == GoogleTranslationAPIError.unauthorized.userFriendlyDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs402() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 402,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data()
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssert(error == .paymentRequired)
            XCTAssert(error.errorDescription == GoogleTranslationAPIError.paymentRequired.errorDescription)
            XCTAssert(
                error.userFriendlyDescription == GoogleTranslationAPIError.paymentRequired.userFriendlyDescription)
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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .forbidden)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.forbidden.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, GoogleTranslationAPIError.forbidden.userFriendlyDescription)
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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .notFound)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.notFound.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, GoogleTranslationAPIError.notFound.userFriendlyDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIs405() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 405,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data()
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .notAllowed)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.notAllowed.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, GoogleTranslationAPIError.notAllowed.userFriendlyDescription)
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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .tooManyRequests)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.tooManyRequests.errorDescription)
            XCTAssertEqual(
                error.userFriendlyDescription,
                GoogleTranslationAPIError.tooManyRequests.userFriendlyDescription
            )
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode:
                    Set(-1000...1000)
                    .subtracting(Set([200, 400, 401, 402, 403, 404, 405, 429]))
                    .randomElement() ?? 0,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data()
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == .invalidRequest)
            XCTAssertEqual(error.errorDescription, GoogleTranslationAPIError.invalidRequest.errorDescription)
            XCTAssertEqual(
                error.userFriendlyDescription,
                GoogleTranslationAPIError.invalidRequest.userFriendlyDescription
            )
        }
    }

    func testNetworkCallSuccess() async throws {

        // Given.

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
                    "data": {
                        "translations": [
                            {
                                "translatedText": "Bonsoir"
                            }
                        ]
                    }
                }
                """.utf8)
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let result = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
            XCTAssertEqual(result, "Bonsoir")
        } catch {
            XCTAssertNil(error)
        }
    }
}
