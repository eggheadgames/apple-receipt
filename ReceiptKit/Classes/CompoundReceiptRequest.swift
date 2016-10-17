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
        beginParsing(receiptType: .production)
    }

}

private extension CompoundReceiptRequest {

    func beginParsing(receiptType: ReceiptType) {
        let receiptRequest = ReceiptRequest(receiptData: receiptData, receiptType: receiptType)
        receiptRequest.delegate = self
        receiptRequest.start()
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
            didFinishParsing(productionReceipt: receipt)
        case .sandbox:
            didFinishParsing(sandboxReceipt: receipt)
        }
    }

    func didFinishParsing(productionReceipt: Receipt?) {
        if let receipt = productionReceipt {
            delegate?.compoundReceiptRequest(self, didRetrieve: receipt)
        } else {
            beginParsing(receiptType: .sandbox)
        }
    }

    func didFinishParsing(sandboxReceipt: Receipt?) {
        delegate?.compoundReceiptRequest(self, didRetrieve: sandboxReceipt)
    }

}
