//
//  SwiftlyAlertMessage.swift
//  SwiftlyAlertMessage
//
//  Created by Nick Berendsen on 06/09/2023.
//

import SwiftUI

/// The structure for an Alert Message
public struct AlertMessage {

    /// Init the alert message
    /// - Parameters:
    ///   - error: The `Error`
    ///   - role: The optional role of the *confirm* `Button`
    ///   - action: The optional action of the *confirm* `Button`
    public init(error: Error, role: ButtonRole? = nil, action: (() -> Void)? = nil) {
        self.error = error
        self.role = role
        self.action = action
    }
    let error: Error
    let role: ButtonRole?
    let action: (() -> Void)?
}

extension AlertMessage {

    /// Wrap an `Error` into a `LocalizedError`
    ///
    /// This to avoid an error:
    /// Protocol ‘LocalizedError’ as a type cannot conform to the protocol itself
    struct LocalizedAlertError: LocalizedError {
        let underlyingError: LocalizedError
        var errorDescription: String? {
            underlyingError.errorDescription
        }
        var recoverySuggestion: String? {
            underlyingError.recoverySuggestion
        }
        var failureReason: String? {
            underlyingError.failureReason
        }
        var helpAnchor: String? {
            underlyingError.helpAnchor
        }

        init?(error: Error?) {
            if let localizedError = error as? LocalizedError {
                underlyingError = localizedError
            } else if let bridge = error as? NSError {
                underlyingError = LocalizedAlertCustomError(
                    errorDescription: bridge.localizedDescription,
                    recoverySuggestion: bridge.localizedRecoverySuggestion,
                    failureReason: bridge.localizedFailureReason
                )
            } else {
                return nil
            }
        }
    }

    /// Create a custom `LocalizedError`
    /// - Note: This is to wrap a `NSError` into the modern world
    struct LocalizedAlertCustomError: LocalizedError {
        init(
            errorDescription: String? = nil,
            recoverySuggestion: String? = nil,
            failureReason: String? = nil,
            helpAnchor: String? = nil
        ) {
            self.errorDescription = errorDescription
            self.recoverySuggestion = recoverySuggestion
            self.failureReason = failureReason
            self.helpAnchor = helpAnchor
        }

        var errorDescription: String?
        var recoverySuggestion: String?
        var failureReason: String?
        var helpAnchor: String?
    }
}

extension AlertMessage {

    /// SwiftUI `View` with the confirmation button
    struct ConfirmButton: View {
        /// The ``AlertMessage``
        @Binding var message: AlertMessage?
        /// The `LocalizedError`
        var localizedAlertError: LocalizedError?
        var body: some View {
            Button(localizedAlertError?.helpAnchor ?? "OK", role: message?.role) {
                if let action = message?.action {
                    action()
                }
                message = nil
            }
        }
    }
}

public extension View {

    /// Show an `Error Alert`
    /// - Parameter message: The ``AlertMessage``
    /// - Returns: A SwiftUI alert with the error message
    func errorAlert(message: Binding<AlertMessage?>) -> some View {
        let localizedAlertError = AlertMessage.LocalizedAlertError(error: message.wrappedValue?.error)
        return alert(
            isPresented: .constant(localizedAlertError != nil),
            error: localizedAlertError,
            actions: { _ in
                AlertMessage.ConfirmButton(message: message, localizedAlertError: localizedAlertError)
            },
            message: { error in
                Text(error.recoverySuggestion ?? "")
            }
        )
    }
}

public extension View {

    /// Show a `Confirmation Dialog`
    /// - Parameter message: The ``AlertMessage``
    /// - Returns: A SwiftUI confirmationDialog
    func confirmationDialog(message: Binding<AlertMessage?>) -> some View {
        let localizedAlertError = AlertMessage.LocalizedAlertError(error: message.wrappedValue?.error)
        return confirmationDialog(
            localizedAlertError?.errorDescription ?? "Confirm",
            isPresented: .constant(localizedAlertError != nil),
            actions: {
                AlertMessage.ConfirmButton(message: message, localizedAlertError: localizedAlertError)
                Button("Cancel", role: .cancel) {
                    message.wrappedValue = nil
                }
            },
            message: {
                Text(localizedAlertError?.recoverySuggestion ?? "")
            }
        )
    }
}

public extension Error {

    /// Create a ``AlertMessage`` from an Error
    /// - Parameters:
    ///   - role: The optional role of the *confirm* `Button`
    ///   - action: The optional action of the *confirm* `Button`
    /// - Returns: A formatted ``AlertMessage``
    func alert(role: ButtonRole? = nil, action: (() -> Void)? = nil) -> AlertMessage {
        return AlertMessage(error: self, role: role, action: action)
    }
}
