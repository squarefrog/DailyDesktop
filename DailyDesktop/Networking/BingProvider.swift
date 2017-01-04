//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/**
 *  A networking provider for working with the Bing image of the day API.
 */
struct BingProvider {

    /// The `NSURLSession` to perform network requests through.
    let session: URLSession

    /// The base URL for the image API call
    let baseURL = URL(string: "http://www.bing.com/HPImageArchive.aspx?format=js")!

    /**
     An initialiser which takes in an `NSURLSession`, and returns a new instance
     of a `BingProvider`.
     */
    init(withSession session: URLSession) {
        self.session = session
    }

    /**
     Fetch the latest image of the day.

     - parameter completion: Returns a `Result` case when the network call
         completes.
     */
    func fetchLatestImage(_ completion: @escaping (Result<Data>) -> Void) {
        fetchLatestImages(withCount: 1, completion: completion)
    }

    /**
     Fetch the last `n` images of the day.

     - parameter count:      The number of images to return.
     - parameter completion: Returns a `Result` case when the network call
         completes.
     */
    func fetchLatestImages(withCount count: Int, completion: @escaping (Result<Data>) -> Void) {
        let url = buildImageRequestURL(withCount: count)
        session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error as? NSError {
                return completion(.failure(BingProviderError.networkError(error)))
            }

            guard let urlResponse = response as? HTTPURLResponse else {
                return completion(.failure(BingProviderError.emptyResponse))
            }

            switch urlResponse.statusCode {
            case 200...299: break
            default:
                return completion(.failure(BingProviderError.httpCode(urlResponse.statusCode)))
            }

            guard let validData = data else {
                return completion(.failure(BingProviderError.emptyData))
            }

            completion(.success(validData))
        })
    }

    /**
     Builds an image request URL with a supplied image count.
     */
    private func buildImageRequestURL(withCount count: Int) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems
        queryItems?.append(URLQueryItem(name: "idx", value: "0"))
        queryItems?.append(URLQueryItem(name: "n", value: "\(count)"))
        components.queryItems = queryItems

        return components.url!
    }

}
