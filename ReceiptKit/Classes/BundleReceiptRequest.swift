//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import StoreKit

// MARK: Delegate

public protocol BundleReceiptRequestDelegate: class {

    func bundleReceiptRequest(bundleReceiptRequest: BundleReceiptRequest, didRetrieveReceipt receipt: Receipt?)

}

// MARK: Main

public final class BundleReceiptRequest: NSObject {

    public let bundle: NSBundle
    public weak var delegate: BundleReceiptRequestDelegate?

    public init(bundle: NSBundle = NSBundle.mainBundle(), delegate: BundleReceiptRequestDelegate? = nil) {
        self.bundle = bundle
        self.delegate = delegate
    }

}

// MARK: Retrieving purchase date

public extension BundleReceiptRequest {

    func start() {
        let receiptRefreshRequest = SKReceiptRefreshRequest()
        receiptRefreshRequest.delegate = self
        receiptRefreshRequest.start()
    }

}

// MARK: Compound receipt request delegate

extension BundleReceiptRequest: CompoundReceiptRequestDelegate {

    func compoundReceiptRequest(compoundReceiptRequest: CompoundReceiptRequest, didRetrieveReceipt receipt: Receipt?) {
        delegate?.bundleReceiptRequest(self, didRetrieveReceipt: receipt)
    }

}

// MARK: Load receipt data

private extension BundleReceiptRequest {

    var receiptData: NSData? {
        guard let receiptURL = receiptURL else { return nil }
        return NSData(contentsOfURL: receiptURL)
    }

    var receiptURL: NSURL? {
        return bundle.appStoreReceiptURL
    }

}

// MARK: Request delegate (Store Kit)

extension BundleReceiptRequest: SKRequestDelegate {

    public func requestDidFinish(request: SKRequest) {
        guard let compoundReceiptRequest = instantiateCompoundReceiptRequest() else {
            delegate?.bundleReceiptRequest(self, didRetrieveReceipt: nil)
            return
        }
        compoundReceiptRequest.start()
    }

    public func request(request: SKRequest, didFailWithError error: NSError) {
        delegate?.bundleReceiptRequest(self, didRetrieveReceipt: nil)
    }

}

// MARK: Receipt controller

private extension BundleReceiptRequest {

    func instantiateCompoundReceiptRequest() -> CompoundReceiptRequest? {
        guard let receiptData = receiptData else { return nil }
        let compoundReceiptRequest = CompoundReceiptRequest(receiptData: receiptData)
        compoundReceiptRequest.delegate = self
        return compoundReceiptRequest
    }

}
