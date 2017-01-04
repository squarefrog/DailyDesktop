//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/// Errors returned by BingProvider
///
/// - httpCode: If network request code is not in the 200-299 range
/// - emptyData: Server returned empty data
/// - emptyResponse: Server returned empty response
/// - networkError: Network failure
enum BingProviderError: Error {
    case httpCode(Int)
    case emptyData
    case emptyResponse
    case networkError(NSError)
}

extension BingProviderError {
    var code: Int {
        switch self {
        case .httpCode(let c):
            return c
        case .emptyData:
            return -6000
        case .emptyResponse:
            return -6001
        case .networkError(let e):
            return e.code
        }
    }
}

extension BingProviderError {
    var failureReason: String {
        switch self {
        case .httpCode(let code):
            return "Server returned \(code) status code."
        case .emptyData:
            return "Server returned empty data."
        case .emptyResponse:
            return "Server returned empty response."
        case .networkError(let e):
            return e.localizedDescription
        }
    }
}

extension BingProviderError: Equatable { }
func == (lhs: BingProviderError, rhs: BingProviderError) -> Bool {
    switch (lhs, rhs) {
    case (.httpCode(let l), .httpCode(let r)):
        return l == r
    default:
        return lhs.code == rhs.code
    }
}

func == (lhs: BingProviderError?, rhs: BingProviderError) -> Bool {
    guard let lhs = lhs else { return false }
    return lhs == rhs
}
