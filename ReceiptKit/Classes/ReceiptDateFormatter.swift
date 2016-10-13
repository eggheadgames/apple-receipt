import Foundation

// MARK: Main

final class ReceiptDateFormatter {}

// MARK: Date formatter

extension ReceiptDateFormatter {

    static func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: ReceiptDateFormatter.locale)
        dateFormatter.dateFormat = ReceiptDateFormatter.dateFormat
        return dateFormatter.date(from: string)
    }

}

private extension ReceiptDateFormatter {

    static let locale = "en_US_POSIX"
    static let dateFormat = "yyyy-MM-dd HH:mm:ss VV"

}
