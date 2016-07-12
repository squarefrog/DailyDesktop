//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

typealias JSONDictionary = [String: AnyObject]

/**
 A list of errors which may be thrown when mapping Bing JSON data to `ImageModel`

 - InvalidData:       Can be thrown if one of the expected JSON keys is missing,
     or if the value is an unexpected type.
 - UnableToParseDate: Is thrown if the image date cannot be parsed.
 */
enum BingParserError: ErrorType {
    case InvalidData(AnyObject)
    case UnableToParseDate(String)
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
    func parseData(data: NSData) throws -> [ImageModel] {
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])

        guard let images = json["images"] as? [AnyObject] else {
            throw BingParserError.InvalidData(json)
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"

        return try images.flatMap { item in
            guard let json = item as? JSONDictionary else { return nil }
            return try ImageModel(bingJSON: json, dateFormatter: dateFormatter)
        }

    }

}

extension ImageModel {
    init?(bingJSON json: JSONDictionary, dateFormatter: NSDateFormatter) throws {
        guard
            let startDate = json["startdate"] as? String,
            let urlPath = json["url"] as? String,
            let description = json["copyright"] as? String,
            let copyrightLink = json["copyrightlink"] as? String,
            let url = NSURL(string: "http://www.bing.com\(urlPath)"),
            let webPageURL = NSURL(string: copyrightLink)
            else {
                throw BingParserError.InvalidData(json)
        }

        guard let date = dateFormatter.dateFromString(startDate) else {
            throw BingParserError.UnableToParseDate(startDate)
        }

        self.date = date
        self.url = url
        self.title = nil
        self.description = description
        self.webPageURL = webPageURL
    }
}
