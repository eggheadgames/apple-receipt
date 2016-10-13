//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import Foundation

// MARK: Delegate

protocol ReceiptRequestDelegate: class {

    func receiptRequest(_ receiptRequest: ReceiptRequest, didRetrieve receipt: Receipt?)

}

// MARK: Main

final class ReceiptRequest {

    let receiptData: Data
    let receiptType: ReceiptType

    weak var delegate: ReceiptRequestDelegate?

    fileprivate weak var queue: OperationQueue?
    fileprivate lazy var session = URLSession(configuration: URLSessionConfiguration.default)

    init(receiptData: Data, receiptType: ReceiptType) {
        self.receiptData = receiptData
        self.receiptType = receiptType
    }

}

enum ReceiptType {

    case sandbox
    case production

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

    func newDataTask() -> URLSessionDataTask {
        return session.dataTask(with: request) { [delegate, queue] data, response, error in
            var JSONObject: AnyObject? {
                guard let data = data else { return nil }
                return try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            }
            var receipt: Receipt? {
                guard let JSONObject = JSONObject else { return nil }
                return Receipt(JSONObject: JSONObject)
            }
            OperationQueue.main.addOperation {
                delegate?.receiptRequest(self, didRetrieve: receipt)
            }
        }
    }

}

// MARK: URL request

private extension ReceiptRequest {

    var request: URLRequest {
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "POST"
        request.httpBody = requestData
        return request as URLRequest
    }

    var requestData: Data {
        do {
            return try JSONSerialization.data(withJSONObject: requestDictionary, options: [])
        } catch {
            preconditionFailure("Invalid request data")
        }
    }

    var requestDictionary: [String: String] {
        let key = ReceiptRequest.requestReceiptDataKey
        let value = receiptData.base64EncodedString(options: [])
        return [key: value]
    }

    static let requestReceiptDataKey = "receipt-data"

}

// MARK: URL

private extension ReceiptRequest {

    var URL: Foundation.URL {
        guard let URL = Foundation.URL(string: URLString) else {
            preconditionFailure("Invalid receipt validation URL")
        }
        return URL
    }

    var URLString: String {
        switch receiptType {
        case .sandbox:
            return ReceiptRequest.sandboxURL
        case .production:
            return ReceiptRequest.productionURL
        }
    }

    static let sandboxURL = "https://sandbox.itunes.apple.com/verifyReceipt"
    static let productionURL = "https://buy.itunes.apple.com/verifyReceipt"

}
