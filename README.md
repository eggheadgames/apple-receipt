[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Description

`Receipt`: Retrieve a fresh and valid receipt for the current environment.

## Installation

### CocoaPods

Add this line to your [`Podfile`](http://guides.cocoapods.org/using/using-cocoapods.html):

```
pod 'ReceiptKit', :git => 'https://github.com/eggheadgames/ReceiptKit.git'
```

And run `pod install`.

### Carthage

Add this line to your [`Cartfile`](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "eggheadgames/ReceiptKit"
```

And run `carthage update`.

## Usage

1. Instantiate `BundleReceiptRequest`:
    ```swift
    let bundleReceiptRequest = BundleReceiptRequest(delegate: self)
    ```

2. Start fetching:
    ```swift
    bundleReceiptRequest.start()
    ```

3. Implement `BundleReceiptRequestDelegate` to retrieve `Receipt`:
    ```swift
    func bundleReceiptRequest(bundleReceiptRequest: BundleReceiptRequest, didRetrieveReceipt receipt: Receipt?) {

        guard let receipt = receipt where receipt.status == 0 else {
            handleMissingReceipt()
        }

        if let purchaseDate = receipt?.purchaseDate {
            processApplicationPurchaseDate(purchaseDate)
        }

    }
    ```
