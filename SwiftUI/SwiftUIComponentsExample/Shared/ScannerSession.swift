//
//  ScannerSession.swift
//  SwiftUIComponentsExample
//
//  Small helpers that all classic scanner examples share.
//

import SwiftUI
import Combine
import ScanbotSDK

/// Wraps an error so that it can be used with SwiftUI's `alert(item:)`.
struct ScannerError: Identifiable {
    let id = UUID()
    let message: String
    
    init(_ error: Error) {
        self.message = error.localizedDescription
    }
}

/// Holds the result and the error of a running scanner example and makes sure
/// that only one result at a time is presented.
final class ScannerSessionState: ObservableObject {
    
    @Published var result: ScanResult?
    @Published var error: ScannerError?
    
    /// While a result is presented, the scanner must stop delivering new ones.
    var isAcceptingResults: Bool {
        return result == nil && error == nil
    }
    
    func present(_ result: ScanResult) {
        guard isAcceptingResults else { return }
        self.result = result
    }
    
    func present(error: Error) {
        guard isAcceptingResults else { return }
        if let sdkError = error as? SBSDKError, sdkError.isCanceled { return }
        self.error = ScannerError(error)
    }
}

extension View {
    
    /// Subscribes to the event subject of a scanner's frame engine.
    ///
    /// The scanners publish their events on the frame processing queue, this delivers
    /// them on the main thread so that the view can update its state directly.
    func onScannerEvent<P: Publisher>(_ publisher: P,
                                      perform action: @escaping (P.Output) -> Void) -> some View where P.Failure == Never {
        return onReceive(publisher) { output in
            if Thread.isMainThread {
                action(output)
            } else {
                DispatchQueue.main.async { action(output) }
            }
        }
    }
    
    /// Presents the result of a scanner example modally and shows errors in an alert.
    func scannerSession(_ state: ScannerSessionState) -> some View {
        self
            .sheet(item: Binding(get: { state.result }, set: { state.result = $0 })) { result in
                ScanResultView(result: result)
            }
            .alert(item: Binding(get: { state.error }, set: { state.error = $0 })) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
    }
}
