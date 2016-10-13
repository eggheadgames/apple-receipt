//  Copyright © 2016 Egghead Games LLC. All rights reserved.

import Foundation

// MARK: Main

public struct Receipt {

    fileprivate let dictionaryRepresentation: NSDictionary

    init?(JSONObject: AnyObject) {
        guard let dictionaryRepresentation = JSONObject as? NSDictionary else { return nil }
        self.dictionaryRepresentation = dictionaryRepresentation
        if status != 0 { return nil }
    }

}

// MARK: Get status

public extension Receipt {

    var status: Int? {
        let key = Receipt.statusKey
        return dictionaryRepresentation[key] as? Int
    }

    fileprivate static let statusKey = "status"

}

// MARK: Parse environment

public extension Receipt {

    var environment: String? {
        let key = Receipt.environmentKey
        return dictionaryRepresentation[key] as? String
    }

    fileprivate static let environmentKey = "environment"

}

// MARK: Parse purchase date

public extension Receipt {

    var purchaseAt: Date? {
        let keys = Receipt.purchaseDateKeys
        guard let rawReceipt = dictionaryRepresentation[keys.0] as? NSDictionary else { return nil }
        guard let rawDate = rawReceipt[keys.1] as? String else { return nil }
        return ReceiptDateFormatter.date(from: rawDate)
    }

    fileprivate static let purchaseDateKeys = ("receipt", "original_purchase_date")

}
