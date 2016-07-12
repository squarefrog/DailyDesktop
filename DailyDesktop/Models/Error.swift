//  Copyright © 2016 Paul Williamson. All rights reserved.

import Foundation

class Error: NSError {

    enum ErrorCode {
        case HTTPCode(Int)
        case EmptyData
        case EmptyResponse

        var code: Int {
            switch self {
            case .HTTPCode(let code):
                return code
            case .EmptyData:
                return -6000
            case .EmptyResponse:
                return -6001
            }
        }

        var failureReason: String {
            switch self {
            case .HTTPCode(let code):
                return "Server returned \(code) status code."
            case .EmptyData:
                return "Server returned empty data."
            case .EmptyResponse:
                return "Server returned empty response."
            }
        }
    }

    convenience init(errorCode: ErrorCode) {
        let domain = "uk.co.squarefrog.dailydesktop"
        let userInfo = [NSLocalizedDescriptionKey: errorCode.failureReason]
        self.init(domain: domain, code: errorCode.code, userInfo: userInfo)
    }
}
