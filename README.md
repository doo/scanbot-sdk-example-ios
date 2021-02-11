# Document scanner SDK and MRZ, QR code, barcode scanner

## Scanbot SDK example apps for iOS

These example apps show how to integrate the [Scanbot SDK](https://scanbot.io) for iOS.


## What is Scanbot SDK?

Scanbot SDK for iOS is a simple to use high level API, providing a collection of classes and functions
for scanning and processing documents from your mobile device's camera or other image sources like your photo library.

Integrate our Ready-To-Use UI Components with only a few lines of code.
Benefit from a proven user experience, super fast integration time and customizable colors and text to match your brand.
Or dive into our Classical UI Components and build your fully customized scanning experience.

Scanbot SDK consists of a bunch of modules, each individually licensable or available in license packages.

Currently the following modules and features are available:
- Document Detection in digital images
- User interface for guided, automatic document scanning using the document detection module
- Image Processing for rotating, cropping, filtering and perspective correction, optimized for the needs of document
scanning
- PDF Creation - merge a collection of processed or unprocessed document images and write them into a PDF document with
one page per image
- Optical Character Recognition - recognize text in document images and create searchable PDF documents with
selectable text
- Payform Recognition, detect and recognize SEPA payforms on images and extract the important data fields via OCR
- Recognition and Data Extraction from German Medical Certificate forms (also known as Disability Certificate or AU-Bescheinigung)
- MRZ Scanner - Provides the ability to find and extract Machine Readable Zone (MRZ) content from ID cards, passports and travel documents



## Documentation

[View Scanbot SDK Online documentation](https://scanbotsdk.github.io/documentation/ios/)



## How to run this example app?

- Clone this repository to a local folder
- Open `ScanbotSDKDemo.xcodeproj` with Xcode, build and run, a build script will automatically download ScanbotSDK to your project folder if needed

- In case you do not want to automatically download the SDK in the Demo apps target, remove the dependency to the 'Download ScanbotSDK' aggregate target and perform the following steps:
  * [Download the latest Scanbot SDK for iOS from our website](https://scanbot.io/en/sdk/documentation)
  * Unzip the downloaded zip file and copy the extracted `ScanbotSDK` folder to your local example app folder (`scanbot-sdk-example-ios/ScanbotSDK`)
  * For Classical UI open `ScanbotSDKDemo.xcodeproj` with Xcode, build and run
  * For Ready-To-Use UI open `ReadyToUseUIDemo.xcodeproj` with Xcode, build and run


## Please note

The Scanbot SDK will run without a license for one minute per session!

After the trial period is over all Scanbot SDK functions as well as the UI components (like Document Scanner UI) will stop working or may be terminated.
You have to restart the app to get another trial period.

To get an unrestricted "no-strings-attached" 30 day trial license, please submit the [Trial License Form](https://scanbot.io/en/sdk/demo/trial) on our website.
