//
//  EmailPage.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI
import SwiftUINavigation

struct EmailPage: View {
    @State var email: String = ""
    @State var toggleOn: Bool = false

    @State var keyboardVisible: Bool = false
    @State var showAlert: AlertState<EmailPage.AlertAction>?
    @State var processing: Bool = false

    var actionHandler: (Action) async -> (ActionResult)

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            if !keyboardVisible {
                VStack(alignment: .center, spacing: DesignConstants.Spacing.doubleCompactStack) {
                    HStack {
                        Image(uiImage: UIImage.fromPackage(named: "CoupleWithMoon"))
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(maxWidth: 260)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    Title(text: "Sign up in less than 2 minutes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .transition(.headerTransition)
            } else {
                Spacer()
            }

            TextField("Email Address", text: $email)
                .textContentType(.emailAddress)
                .typeStyle(.field)
                .padding()
                .background(Color.secondaryBackground)
                .disabled(processing)

            HStack {
                MinimalButton(
                    text: "Send link",
                    style: .primary,
                    prominence: .regular, action: {
                        processing = true
                        Task {
                            let result = await actionHandler(.sendLink(email: email.lowercased()))
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

            detailsToggle
        }
        .animation(.easeInOut, value: keyboardVisible)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .onReceive(keyboardPublisher, perform: { keyboardVisible = $0 })
        .alert(unwrapping: $showAlert) { _ in self.showAlert = nil }
    }

    var detailsToggle: some View {
        HStack {
            Text("Remember login details")
                .font(MinimalFont.Manrope.regular.font(size: 12, relativeTo: .caption))
            Spacer()
            Toggle(isOn: $toggleOn.sideEffect(onSet: { (newValue, _) in
                Task {
                    _ = await actionHandler(.toggleRememberDetails(remember: newValue))
                }
            }), label: { })
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.text)
            )
        }
    }

    enum Action {
        case sendLink(email: String)
        case toggleRememberDetails(remember: Bool)
    }

    enum ActionResult {
        case none
        case error(alert: AlertState<AlertAction>)
    }

    enum AlertAction {
        case dismiss
    }
}

struct EmailPage_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        var body: some View {
            MinimalThemeContainer {
                EmailPage(actionHandler: handle(action:))
            }
        }

        func handle(action: EmailPage.Action) async -> (EmailPage.ActionResult) {
            return .none
        }
    }
}
