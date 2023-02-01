//
//  PhoneNumberEntryPage.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI
import SwiftUINavigation

struct PhoneNumberEntryPage: View {
    @State var phoneNumber: String

    @State var keyboardVisible: Bool = false
    @State var showAlert: AlertState<PhoneNumberEntryPage.AlertAction>?
    @State var processing: Bool = false

    var actionHandler: (Action) async -> (ActionResult)

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            if !keyboardVisible {
                VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
                    Header(text: "What's your phone number?", image: "StrangeEyes")
                    Text("We need to make sure you're you. Please let us know what number to send a code to.")
                        .typeStyle(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.headerTransition)
            }

            if keyboardVisible { Spacer() }

            TextField("Phone Number", text: $phoneNumber)
                .typeStyle(.field)
                .padding()
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .background(Color.secondaryBackground)
                .disabled(processing)

            if !keyboardVisible { Spacer() }

            HStack {
                MinimalButton(
                    text: "Send code",
                    style: .primary,
                    prominence: .regular, action: {
                        processing = true
                        Task {
                            let result = await actionHandler(.sendMessage(number: phoneNumber))
                            if case .error(let alert) = result {
                                self.showAlert = alert
                            }
                            processing = false
                        }
                    })
                    .disabled(processing)
            }
            .overlay(
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primaryBackground))
                }
                .padding(.horizontal)
                .opacity(processing ? 1 : 0)
            )
        }
        .animation(.easeInOut, value: keyboardVisible)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .onReceive(keyboardPublisher, perform: { keyboardVisible = $0 })
        .alert(unwrapping: $showAlert) { _ in self.showAlert = nil }
    }

    enum Action {
        case sendMessage(number: String)
    }

    enum ActionResult {
        case none
        case error(alert: AlertState<AlertAction>)
    }

    enum AlertAction {
        case dismiss
    }
}

struct PhoneNumberEntryPage_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        var body: some View {
            MinimalThemeContainer {
                PhoneNumberEntryPage(
                    phoneNumber: "",
                    actionHandler: handle(action:)
                )
            }
        }

        func handle(action: PhoneNumberEntryPage.Action) async -> PhoneNumberEntryPage.ActionResult {
            return .none
        }
    }
}
