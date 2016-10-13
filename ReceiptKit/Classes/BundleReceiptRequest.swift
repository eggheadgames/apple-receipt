//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import StoreKit

// MARK: Delegate

public protocol BundleReceiptRequestDelegate: class {

    func bundleReceiptRequest(_ bundleReceiptRequest: BundleReceiptRequest, didRetrieve receipt: Receipt?)

}

// MARK: Main

public final class BundleReceiptRequest: NSObject {

    public let bundle: Bundle
    public weak var delegate: BundleReceiptRequestDelegate?

    public init(bundle: Bundle = Bundle.main, delegate: BundleReceiptRequestDelegate? = nil) {
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

    func compoundReceiptRequest(_ compoundReceiptRequest: CompoundReceiptRequest, didRetrieve receipt: Receipt?) {
        delegate?.bundleReceiptRequest(self, didRetrieve: receipt)
    }

}

// MARK: Load receipt data

private extension BundleReceiptRequest {

    var receiptData: Data? {
        guard let receiptURL = receiptURL else { return nil }
        return try? Data(contentsOf: receiptURL)
    }

    var receiptURL: URL? {
        return bundle.appStoreReceiptURL
    }

}

// MARK: Request delegate (Store Kit)

extension BundleReceiptRequest: SKRequestDelegate {

    public func requestDidFinish(_ request: SKRequest) {
        guard let compoundReceiptRequest = instantiateCompoundReceiptRequest() else {
            delegate?.bundleReceiptRequest(self, didRetrieve: nil)
            return
        }
        compoundReceiptRequest.start()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        delegate?.bundleReceiptRequest(self, didRetrieve: nil)
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
