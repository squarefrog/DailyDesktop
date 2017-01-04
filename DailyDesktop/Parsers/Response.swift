//
//  Copyright © 2017 Paul Williamson. All rights reserved.
//

import Foundation

/// Declared as enum so it can never be instantiated
enum Response {

    typealias DataResult = Result<Data>

    /// Parse the result of a URLSession data task, and return a Result case
    ///
    /// - Parameters:
    ///   - data: The data returned by the server
    ///   - response: The response metadata
    ///   - error: An error object that indicates why the request failed
    /// - Returns: A parsed result case
    static func parse(data: Data?, response: URLResponse?, error: Error?) -> DataResult {
        if let error = error as? NSError {
            return .failure(BingProviderError.networkError(error))
        }

        guard let urlResponse = response as? HTTPURLResponse else {
            return .failure(BingProviderError.emptyResponse)
        }

        switch urlResponse.statusCode {
        case 200...299:
            break
        default:
            return .failure(BingProviderError.httpCode(urlResponse.statusCode))
        }

        guard let validData = data else {
            return .failure(BingProviderError.emptyData)
        }

        return .success(validData)
    }
}
