//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

typealias JSONDictionary = [String: AnyObject]

/**
 A list of errors which may be thrown when mapping Bing JSON data to `ImageModel`

 - invalidData:       Can be thrown if one of the expected JSON keys is missing,
     or if the value is an unexpected type.
 - unableToParseDate: Is thrown if the image date cannot be parsed.
 */
enum BingParserError: Swift.Error {
    case invalidData(Any?)
    case unableToParseDate(String)
}

struct BingImageParser {

    /**
     Parse `NSData` returned from Bing into an array of `ImageModel` objects.

     - parameter data: The data returned by Bing.

     - throws: Can throw if supplied data cannot be serialised into JSON.
         Additionally cant throw `ParserError` if unable to find required values
         in supplied data.

     - returns: An array of `ImageModel` objects.
     */
    func parseData(_ data: Data) throws -> [ImageModel] {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]

        guard let images = json?["images"] as? [AnyObject] else {
            throw BingParserError.invalidData(json)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        return try images.flatMap { item in
            guard let json = item as? JSONDictionary else { return nil }
            return try ImageModel(json: json, dateFormatter: dateFormatter)
        }

    }

}

extension ImageModel {
    init?(json: JSONDictionary, dateFormatter: DateFormatter) throws {
        guard
            let startDate = json["startdate"] as? String,
            let urlPath = json["url"] as? String,
            let description = json["copyright"] as? String,
            let copyrightLink = json["copyrightlink"] as? String,
            let url = URL(string: "http://www.bing.com\(urlPath)"),
            let webPageURL = URL(string: copyrightLink)
            else {
                throw BingParserError.invalidData(json as AnyObject)
        }

        guard let date = dateFormatter.date(from: startDate) else {
            throw BingParserError.unableToParseDate(startDate)
        }

        self.date = date
        self.url = url
        self.title = nil
        self.description = description
        self.webPageURL = webPageURL
    }
}
