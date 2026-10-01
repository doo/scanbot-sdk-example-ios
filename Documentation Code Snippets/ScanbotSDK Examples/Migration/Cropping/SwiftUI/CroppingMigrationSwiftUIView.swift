//
//  CroppingMigrationSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CroppingMigrationSwiftUIView: View {

    @State private var image: UIImage?
    @State private var activeCroppingScreen: CroppingScreen?

    @State private var croppingConfiguration = SBSDKUI2CroppingStandaloneConfiguration(documentUuid: "<documentUuid>",
                                                                                       pageUuid: "<pageUuid>")

    @State private var configExampleConfiguration: SBSDKUI2CroppingStandaloneConfiguration = {
        let configuration = SBSDKUI2CroppingStandaloneConfiguration(documentUuid: "<documentUuid>",
                                                                    pageUuid: "<pageUuid>")

        // All the colors can be conveniently set using the Palette object:
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)

        // Now all the text resources are in the localization object.
        configuration.localization.croppingTopBarConfirmButtonTitle = "Apply"

        return configuration
    }()

    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Open Scanner") {
                openScannerTapped()
            }
        }
        .fullScreenCover(item: $activeCroppingScreen) { screen in
            croppingView(configuration: screen == .default ? croppingConfiguration : configExampleConfiguration)
        }
    }

    func openScannerTapped() {
        openCroppingRtuV2()
    }

    func openCroppingRtuV2() {
        activeCroppingScreen = .default
    }

    func configExampleCroppingRtuV2() {
        activeCroppingScreen = .configExample
    }

    @ViewBuilder
    func croppingView(configuration: SBSDKUI2CroppingStandaloneConfiguration) -> some View {
        SBSDKUI2CroppingView(configuration: configuration) { result, error in
            if let error = error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    print("Error editing image: \(error.localizedDescription)")
                }
                activeCroppingScreen = nil
                return
            }
            guard let result = result else {
                activeCroppingScreen = nil
                return
            }
            do {
                let document = try SBSDKScannedDocument.loadDocument(documentUuid: result.documentUuid)
                let page = try document.page(with: result.pageUuid)
                image = try page.documentImage?.toUIImage()
            } catch {
                print("Error editing image: \(error.localizedDescription)")
            }
            activeCroppingScreen = nil
        }
        .ignoresSafeArea()
    }

    enum CroppingScreen: String, Identifiable {
        case `default`
        case configExample

        var id: String { rawValue }
    }
}

#Preview {
    CroppingMigrationSwiftUIView()
}
