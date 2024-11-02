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
        translationAPIService.urlString = ""
        try await testGoogleAPIError(statusCode: Int(), testedError: .invalidURL)
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {
        try await testGoogleAPIError(statusCode: 400, testedError: .badRequest)
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {
        try await testGoogleAPIError(statusCode: 401, testedError: .unauthorized)
    }

    func testNetworkCallFailsWhenStatusCodeIs402() async throws {
        try await testGoogleAPIError(statusCode: 402, testedError: .paymentRequired)
    }

    func testNetworkCallFailsWhenStatusCodeIs403() async throws {
        try await testGoogleAPIError(statusCode: 403, testedError: .forbidden)
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {
        try await testGoogleAPIError(statusCode: 404, testedError: .notFound)
    }

    func testNetworkCallFailsWhenStatusCodeIs405() async throws {
        try await testGoogleAPIError(statusCode: 405, testedError: .notAllowed)
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {
        try await testGoogleAPIError(statusCode: 429, testedError: .tooManyRequests)
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {
        try await testGoogleAPIError(
            statusCode: Set(-1000...1000)
                .subtracting(Set([200, 400, 401, 402, 403, 404, 405, 429]))
                .randomElement() ?? 0,
            testedError: .invalidRequest
        )
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

    private func testGoogleAPIError(statusCode: Int, testedError: GoogleTranslationAPIError) async throws {

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
            _ = try await translationAPIService.fetchTranslation(text: "", source: "", target: "", format: "")
        } catch let error as GoogleTranslationAPIError {
            XCTAssertTrue(error == testedError)
            XCTAssertEqual(error.errorDescription, testedError.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, testedError.userFriendlyDescription)
        }
    }
}
