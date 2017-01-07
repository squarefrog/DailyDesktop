//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/// A networking provider for working with the Bing image of the day API.
struct BingProvider {

    /// The `NSURLSession` to perform network requests on.
    let session: URLSession

    /// The base URL for the image API call
    let baseURL = URL(string: "https://www.bing.com/HPImageArchive.aspx?format=js")!

    /// An initialiser which takes in an `NSURLSession`, and returns a new
    /// instance of a `BingProvider`.
    init(session: URLSession) {
        self.session = session
    }

    /// Fetch the latest image of the day.
    ///
    /// - Parameter completion: Returns a `Result` case when the network call
    ///                         completes.
    func fetchLatestImage(completion: @escaping (Result<Data>) -> Void) {
        fetchLatestImages(count: 1, completion: completion)
    }

    /// Fetch the last `n` images of the day.
    ///
    /// - Parameters:
    ///   - count: The number of images to return.
    ///   - completion: Returns a `Result` case when the network call completes
    func fetchLatestImages(count: Int, completion: @escaping (Result<Data>) -> Void) {
        let url = buildImageRequestURL(count: count)
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            let result = Response.parse(data: data, response: response, error: error)
            completion(result)
        })
        task.resume()
    }

    /// Download an image
    ///
    /// - Parameters:
    ///   - image: An image model containing the URL to download.
    ///   - completion: Returns a `Result` case when the download completes.
    func download(image: ImageModel, completion: @escaping (Result<Data>) -> Void) {
        let task = session.dataTask(with: image.url) { (data, response, error) in
            let result = Response.parse(data: data, response: response, error: error)
            completion(result)
        }
        task.resume()
    }

    /// Builds an image request URL with a supplied image count.
    private func buildImageRequestURL(count: Int) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems
        queryItems?.append(URLQueryItem(name: "idx", value: "0"))
        queryItems?.append(URLQueryItem(name: "n", value: "\(count)"))
        let mkt = NSLocale.current.iso3166code
        queryItems?.append(URLQueryItem(name: "mkt", value: mkt))
        components.queryItems = queryItems

        return components.url!
    }

}
