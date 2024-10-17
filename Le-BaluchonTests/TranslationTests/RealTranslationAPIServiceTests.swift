//
//  Le_BaluchonTests.swift
//  Le-BaluchonTests
//
//  Created by Redouane on 22/08/2024.
//

import XCTest
@testable import Le_Baluchon

final class RealTranslationAPIServiceTests: XCTestCase {

    var translationAPIService: RealTranslationAPIService!

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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .invalidURL)
            XCTAssert(error.errorDescription == GoogleAPIError.invalidURL.errorDescription)
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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .bad_request)
            XCTAssert(error.errorDescription == GoogleAPIError.bad_request.errorDescription)
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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .unauthorized)
            XCTAssert(error.errorDescription == GoogleAPIError.unauthorized.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .payment_required)
            XCTAssert(error.errorDescription == GoogleAPIError.payment_required.errorDescription)
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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .forbidden)
            XCTAssert(error.errorDescription == GoogleAPIError.forbidden.errorDescription)
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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .not_found)
            XCTAssert(error.errorDescription == GoogleAPIError.not_found.errorDescription)
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

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .not_allowed)
            XCTAssert(error.errorDescription == GoogleAPIError.not_allowed.errorDescription)
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
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .too_many_requests)
            XCTAssert(error.errorDescription == GoogleAPIError.too_many_requests.errorDescription)
        }
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {

        // Given.

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: Set(-1000...1000).subtracting(Set([200, 400, 401, 402, 403, 404, 405, 429])).randomElement() ?? 0,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = """
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let _ = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
        } catch let error as GoogleAPIError {
            XCTAssert(error == .invalidRequest)
            XCTAssert(error.errorDescription == GoogleAPIError.invalidRequest.errorDescription)
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

            let mockData = """
                {
                    "data": {
                        "translations": [
                            {
                                "translatedText": "Bonsoir"
                            }
                        ]
                    }
                }
                """.data(using: .utf8)!
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let result = try await translationAPIService.fetchTranslation(q: "", source: "", target: "", format: "")
            XCTAssertEqual(result.data.translations.first?.translatedText, "Bonsoir")
        } catch {
            XCTAssertNil(error)
        }
    }
}