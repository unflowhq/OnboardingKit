//
//  ConfirmationCodePage.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI
import SwiftUINavigation

struct ConfirmationCodePage: View {
    let phoneNumber: String
    @State var code: String

    @State var keyboardVisible: Bool = false
    @State var showAlert: AlertState<ConfirmationCodePage.AlertAction>?
    @State var processing: Bool = false
    @FocusState var field: Field?

    var actionHandler: (Action) async -> (ActionResult)

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.doubleCompactStack) {
                Header(text: "Verify your phone number", image: nil)
                Text("We've sent you a one time verification code to \(phoneNumber)")
                    .typeStyle(.body)
            }
            .padding(.top, keyboardVisible ? DesignConstants.Padding.headerPaddingWithKeyboard : DesignConstants.Padding.headerPaddingWihoutNavigationBar)
            .frame(maxWidth: .infinity, alignment: .leading)

            if keyboardVisible { Spacer() }

            // This keyboard is hidden with opacity so it still works for every other purpose
            // The text is only ever displayed in `CodeDisplayView`
            TextField("", text: .init(get: {
                return self.code
            }, set: { newValue in
                self.code = String(newValue.prefix(6))
            }))
            .typeStyle(.field)
            .keyboardType(.phonePad)
            .focused($field, equals: .code)
            .disabled(processing)
            .opacity(0)

            if !keyboardVisible { Spacer() }

            CodeDisplayView(text: code, isEditing: field == .code)
                .onTapGesture {
                    self.field = .code
                }

            HStack {
                MinimalButton(
                    text: "Confirm",
                    style: .primary,
                    prominence: .regular, action: {
                        processing = true
                        Task {
                            let result = await actionHandler(.verifyCode(number: code))
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
        .onAppear {
            // FocusedField does not always work if you fire on appear, so add a slight delay
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.field = .code
            }
        }
    }

    enum Action {
        case verifyCode(number: String)
    }

    enum ActionResult {
        case none
        case error(alert: AlertState<AlertAction>)
    }

    enum AlertAction {
        case dismiss
    }

    enum Field {
        case code
    }
}

private struct CodeDisplayView: View {
    let text: String
    let isEditing: Bool

    /// This could be improved by showing a border around the current field
    var body: some View {
        HStack {
            let currentlyEditingCharacter: String.Index? = isEditing ? text.endIndex : nil

            ForEach(0..<6, id: \.self) { index in
                let isEditingThisCharacter = currentlyEditingCharacter?.utf16Offset(in: text) == index
                if text.count > index, let character = text[String.Index(utf16Offset: index, in: text)] {
                    characterDisplay(character: String(character), isEditing: isEditingThisCharacter)
                } else {
                    characterDisplay(character: nil, isEditing: isEditingThisCharacter)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func characterDisplay(character: String?, isEditing: Bool) -> some View {
        Text(character ?? "")
            .font(MinimalFont.Inter.semiBold.font(size: 16, relativeTo: .body))
            .padding()
            .frame(
                maxWidth: .infinity,
                minHeight: 74,
                alignment: .center
            )
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color.secondaryBackground)
            )
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .inset(by: -2)
                    .foregroundColor(.text)
                    .opacity(isEditing ? 1 : 0)
            )
            .animation(.easeInOut, value: isEditing)
    }
}

struct ConfirmationCodePage_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        var body: some View {
            MinimalThemeContainer {
                ConfirmationCodePage(
                    phoneNumber: "07375701989",
                    code: "",
                    actionHandler: handle(action:)
                )
            }
        }

        func handle(action: ConfirmationCodePage.Action) async -> ConfirmationCodePage.ActionResult {
            return .none
        }
    }
}
