//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import Foundation

// MARK: Delegate

protocol CompoundReceiptRequestDelegate: class {

    func compoundReceiptRequest(compoundReceiptRequest: CompoundReceiptRequest, didRetrieveReceipt receipt: Receipt?)

}

// MARK: Main

final class CompoundReceiptRequest {

    let receiptData: NSData
    weak var delegate: CompoundReceiptRequestDelegate?

    init(receiptData: NSData) {
        self.receiptData = receiptData
    }

}

// MARK: Parsing

extension CompoundReceiptRequest {

    func start() {
        beginParsingType(.Production)
    }

}

private extension CompoundReceiptRequest {

    func beginParsingType(receiptType: ReceiptType) {
        let receiptRequest = instantiateReceiptRequestWithReceiptType(receiptType)
        receiptRequest.start()
    }

}

// MARK: Receipt request

extension CompoundReceiptRequest {

    func instantiateReceiptRequestWithReceiptType(receiptType: ReceiptType) -> ReceiptRequest {
        let receiptRequest = ReceiptRequest(receiptData: receiptData, receiptType: receiptType)
        receiptRequest.delegate = self
        return receiptRequest
    }

}

// MARK: Receipt request delegate

extension CompoundReceiptRequest: ReceiptRequestDelegate {

    func receiptRequest(receiptRequest: ReceiptRequest, didRetrieveReceipt receipt: Receipt?) {
        didFinishParsingReceipt(receipt, type: receiptRequest.receiptType)
    }

}

private extension CompoundReceiptRequest {

    func didFinishParsingReceipt(receipt: Receipt?, type: ReceiptType) {
        switch type {
        case .Production:
            didFinishParsingProductionReceipt(receipt)
        case .Sandbox:
            didFinishParsingSandboxReceipt(receipt)
        }
    }

    func didFinishParsingProductionReceipt(receipt: Receipt?) {
        if let receipt = receipt {
            delegate?.compoundReceiptRequest(self, didRetrieveReceipt: receipt)
        } else {
            beginParsingType(.Sandbox)
        }
    }

    func didFinishParsingSandboxReceipt(receipt: Receipt?) {
        delegate?.compoundReceiptRequest(self, didRetrieveReceipt: receipt)
    }

}
