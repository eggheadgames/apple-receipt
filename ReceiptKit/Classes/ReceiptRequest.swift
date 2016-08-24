//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import Foundation

// MARK: Delegate

protocol ReceiptRequestDelegate: class {

    func receiptRequest(receiptRequest: ReceiptRequest, didRetrieveReceipt receipt: Receipt?)

}

// MARK: Main

final class ReceiptRequest {

    let receiptData: NSData
    let receiptType: ReceiptType

    weak var delegate: ReceiptRequestDelegate?

    private weak var queue: NSOperationQueue?
    private lazy var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

    init(receiptData: NSData, receiptType: ReceiptType) {
        self.receiptData = receiptData
        self.receiptType = receiptType
    }

}

enum ReceiptType {

    case Sandbox
    case Production

}

// MARK: Fetching receipts

extension ReceiptRequest {

    func start() {
        let dataTask = newDataTask()
        dataTask.resume()
    }

}

// MARK: Data task

private extension ReceiptRequest {

    func newDataTask() -> NSURLSessionDataTask {
        return session.dataTaskWithRequest(request) { [delegate, queue] data, response, error in
            var JSONObject: AnyObject? {
                guard let data = data else { return nil }
                return try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            }
            var receipt: Receipt? {
                guard let JSONObject = JSONObject else { return nil }
                return Receipt(JSONObject: JSONObject)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock {
                delegate?.receiptRequest(self, didRetrieveReceipt: receipt)
            }
        }
    }

}

// MARK: URL request

private extension ReceiptRequest {

    var request: NSURLRequest {
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        request.HTTPBody = requestData
        return request
    }

    var requestData: NSData {
        do {
            return try NSJSONSerialization.dataWithJSONObject(requestDictionary, options: [])
        } catch {
            preconditionFailure("Invalid request data")
        }
    }

    var requestDictionary: [String: String] {
        let key = ReceiptRequest.requestReceiptDataKey
        let value = receiptData.base64EncodedStringWithOptions([])
        return [key: value]
    }

    static let requestReceiptDataKey = "receipt-data"

}

// MARK: URL

private extension ReceiptRequest {

    var URL: NSURL {
        guard let URL = NSURL(string: URLString) else {
            preconditionFailure("Invalid receipt validation URL")
        }
        return URL
    }

    var URLString: String {
        switch receiptType {
        case .Sandbox:
            return ReceiptRequest.sandboxURL
        case .Production:
            return ReceiptRequest.productionURL
        }
    }

    static let sandboxURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    static let productionURL = "https://buy.itunes.apple.com/verifyReceipt"

}
