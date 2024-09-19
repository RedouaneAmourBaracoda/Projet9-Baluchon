//
//  MockURLProtocol.swift
//  Baluchon
//
//  Created by Redouane on 22/08/2024.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else { return }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            print(error)
        }
    }

    override func stopLoading() { }

    static func startInterceptingRequests() { URLProtocol.registerClass(MockURLProtocol.self) }

    static func stopInterceptingRequests() { URLProtocol.unregisterClass(MockURLProtocol.self) }
}

