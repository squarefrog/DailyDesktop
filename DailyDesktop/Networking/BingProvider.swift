//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

/**
 *  A networking provider for working with the Bing image of the day API.
 */
struct BingProvider {

    /// The `NSURLSession` to perform network requests through.
    let session: NSURLSession

    /// The base URL for the image API call
    let baseURL = NSURL(string: "http://www.bing.com/HPImageArchive.aspx?format=js")!

    /**
     An initialiser which takes in an `NSURLSession`, and returns a new instance
     of a `BingProvider`.
     */
    init(withSession session: NSURLSession) {
        self.session = session
    }

    /**
     Fetch the latest image of the day.

     - parameter completion: Returns a `Result` case when the network call
         completes.
     */
    func fetchLatestImage(completion: (Result<NSData>) -> ()) {
        fetchLatestImages(withCount: 1, completion: completion)
    }

    /**
     Fetch the last `n` images of the day.

     - parameter count:      The number of images to return.
     - parameter completion: Returns a `Result` case when the network call
         completes.
     */
    func fetchLatestImages(withCount count: Int, completion: (Result<NSData>) -> ()) {
        let url = buildImageRequestURL(withCount: count)
        session.dataTaskWithURL(url) { data, response, error in
            guard error == nil else { return completion(.Failure(error!)) }

            guard let urlResponse = response as? NSHTTPURLResponse else {
                return completion(.Failure(Error(errorCode: .EmptyResponse)))
            }

            switch urlResponse.statusCode {
            case 200...299: break
            default:
                let error = Error(errorCode: .HTTPCode(urlResponse.statusCode))
                return completion(.Failure(error))
            }

            guard let validData = data else {
                return completion(.Failure(Error(errorCode: .EmptyData)))
            }

            completion(.Success(validData))
        }

    }

    /**
     Builds an image request URL with a supplied image count.
     */
    private func buildImageRequestURL(withCount count: Int) -> NSURL {
        let components = NSURLComponents(URL: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems
        queryItems?.append(NSURLQueryItem(name: "idx", value: "0"))
        queryItems?.append(NSURLQueryItem(name: "n", value: "\(count)"))
        components.queryItems = queryItems

        return components.URL!
    }

}
