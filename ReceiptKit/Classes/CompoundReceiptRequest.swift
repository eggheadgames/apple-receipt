//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import Foundation

// MARK: Delegate

protocol CompoundReceiptRequestDelegate: class {

    func compoundReceiptRequest(_ compoundReceiptRequest: CompoundReceiptRequest, didRetrieve receipt: Receipt?)

}

// MARK: Main

final class CompoundReceiptRequest {

    let receiptData: Data
    weak var delegate: CompoundReceiptRequestDelegate?

    init(receiptData: Data) {
        self.receiptData = receiptData
    }

}

// MARK: Parsing

extension CompoundReceiptRequest {

    func start() {
        beginParsingType(.production)
    }

}

private extension CompoundReceiptRequest {

    func beginParsingType(_ receiptType: ReceiptType) {
        let receiptRequest = instantiateReceiptRequestWithReceiptType(receiptType)
        receiptRequest.start()
    }

}

// MARK: Receipt request

extension CompoundReceiptRequest {

    func instantiateReceiptRequestWithReceiptType(_ receiptType: ReceiptType) -> ReceiptRequest {
        let receiptRequest = ReceiptRequest(receiptData: receiptData, receiptType: receiptType)
        receiptRequest.delegate = self
        return receiptRequest
    }

}

// MARK: Receipt request delegate

extension CompoundReceiptRequest: ReceiptRequestDelegate {

    func receiptRequest(_ receiptRequest: ReceiptRequest, didRetrieve receipt: Receipt?) {
        didFinishParsing(receipt: receipt, type: receiptRequest.receiptType)
    }

}

private extension CompoundReceiptRequest {

    func didFinishParsing(receipt: Receipt?, type: ReceiptType) {
        switch type {
        case .production:
            didFinishParsingProductionReceipt(receipt)
        case .sandbox:
            didFinishParsingSandboxReceipt(receipt)
        }
    }

    func didFinishParsingProductionReceipt(_ receipt: Receipt?) {
        if let receipt = receipt {
            delegate?.compoundReceiptRequest(self, didRetrieve: receipt)
        } else {
            beginParsingType(.sandbox)
        }
    }

    func didFinishParsingSandboxReceipt(_ receipt: Receipt?) {
        delegate?.compoundReceiptRequest(self, didRetrieve: receipt)
    }

}
