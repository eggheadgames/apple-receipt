import Foundation

// MARK: Main

final class ReceiptDateFormatter {}

// MARK: Date formatter

extension ReceiptDateFormatter {

    static func dateFromString(string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: ReceiptDateFormatter.locale)
        dateFormatter.dateFormat = ReceiptDateFormatter.dateFormat
        return dateFormatter.dateFromString(string)
    }

}

private extension ReceiptDateFormatter {

    static let locale = "en_US_POSIX"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss VV"

}
