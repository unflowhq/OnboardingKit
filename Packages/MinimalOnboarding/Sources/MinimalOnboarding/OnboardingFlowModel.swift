//
//  OnboardingFlowModel.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import Foundation
import SwiftUI
import SwiftUINavigation

public class OnboardingFlowModel: ObservableObject {
    private let authService: AuthService
    private let userService: UserService
    private let validationService: ContactValidating
    private let linkParser: LinkParsing
    private let notificationPermissionProvider: NotificationPermissionProviding

    @Published var path: [Screen]
    @Published var state: FlowState

    let handler: (OnboardingAction) -> Void

    public init(
        path: [Screen] = [],
        state: FlowState = .init(rememberDetails: false),
        authService: AuthService = PlaceholderAuthService(),
        userService: UserService = AppStorageUserService(),
        validationService: ContactValidating = ContactValidator(),
        linkParser: LinkParsing = LinkParser(),
        notificationPermissionProvider: NotificationPermissionProviding = NotificationPermissionProvider(),
        handler: @escaping (OnboardingAction) -> Void
    ) {
        self.path = path
        self.state = state
        self.authService = authService
        self.userService = userService
        self.validationService = validationService
        self.linkParser = linkParser
        self.notificationPermissionProvider = notificationPermissionProvider
        self.handler = handler
    }

    func handle(url: URL) {
        switch linkParser.validate(url: url) {
        case .emailVerification(let email):
            // If we're mid flow, make sure we only verify the email we expect
            if let stateEmail = state.email, stateEmail != email { return }
            state.email = email
            if (path.contains(.emailVerification) || path.isEmpty) && !path.contains(.promotion) {
                path.append(.promotion)
            }
        case .none: return
        }
    }

    // MARK: - Intro Actions
    func handleIntroActions(action: IntroPage.Action) {
        switch action {
        case .signIn:
            state.flow = .signIn
            path.append(.signIn)
        case .signUp:
            state.flow = .signUp
            path.append(.signUp)
        }
    }

    // MARK: - Email Actions
    @MainActor
    func handleEmailActions(action: EmailPage.Action) async -> EmailPage.ActionResult {
        switch action {
        case .sendLink(let email):
            guard validationService.validateEmail(string: email) else {
                return .error(alert: makeSimpleAlert(title: "Error", body: "Please enter a valid email.", dismissAction: .dismiss))
            }
            if state.rememberDetails { userService.store(email: email) }
            state.email = email
            let result = await authService.sendValidationEmail(to: email)
            if result {
                path.append(.emailVerification)
                return .none
            } else {
                return .error(alert: makeSimpleAlert(title: "Error", body: "Your email could not be verified at this time", dismissAction: .dismiss))
            }
        case .toggleRememberDetails(let remember):
            if !remember { userService.clear() }
            return .none
        }
    }

    // MARK: - Promo actions
    func handlePromoAction(action: PromotionPage.Action) {
        path.append(.phoneNumberEntry)
    }

    // MARK: - Phone Number Actions
    @MainActor
    func handlePhoneActions(action: PhoneNumberEntryPage.Action) async -> PhoneNumberEntryPage.ActionResult {
        switch action {
        case .sendMessage(let phoneNumber):
            guard validationService.validatePhoneNumber(string: phoneNumber) else {
                return .error(alert: makeSimpleAlert(title: "Error", body: "Please enter a valid phone number.", dismissAction: .dismiss))
            }
            if state.rememberDetails { userService.store(phoneNumber: phoneNumber) }
            state.phoneNumber = phoneNumber
            if let result = await authService.sendValidationCode(to: phoneNumber) {
                state.expectedCode = result
                path.append(.phoneNumberVerification)
                return .none
            } else {
                return .error(alert: makeSimpleAlert(title: "Error", body: "Your phone number could not be verified at this time", dismissAction: .dismiss))
            }
        }
    }

    // MARK: - Phone Validation Actions
    @MainActor
    func handleConfirmationCodeActions(action: ConfirmationCodePage.Action) async -> ConfirmationCodePage.ActionResult {
        switch action {
        case .verifyCode(let number):
            self.state.enteredCode = number
            guard let code = state.expectedCode else {
                // An improvement could be made that this provides an action to re-send a code.
                return .error(alert: makeSimpleAlert(title: "Error", body: "Something has gone wrong. Please re-enter your phone number.", dismissAction: .dismiss))
            }
            guard code == number else {
                return .error(alert: makeSimpleAlert(title: "Error", body: "That's not the code we were expecting.", dismissAction: .dismiss))
            }
            switch state.flow {
            case .signIn:
                path.append(.notifications)
            case .signUp:
                path.append(.phoneConfirmed)
            case .none:
                break
            }
            return .none
        }
    }

    // MARK: - Setup Confirmation Actions
    func handleSetupConfirmationActions(action: SetupConfirmationPage.Action) {
        switch action {
        case .done:
            self.path.append(.notifications)
        }
    }

    // MARK: - Notification Actions
    @MainActor
    func handleNotificationActions(action: NotificationPermissionPage.Action) async -> NotificationPermissionPage.ActionResult {
        switch action {
        case .requestPermissions:
            _ = await notificationPermissionProvider.requestPermission()
            handler(.complete)
            return .none
        case .skip:
            handler(.complete)
            return .none
        }
    }

    // MARK: - AlertHelper
    private func makeSimpleAlert<Action>(title: String, body: String, dismissAction: Action) -> AlertState<Action> {
        AlertState(title: {
            TextState(verbatim: title)
        }, actions: {
            ButtonState(role: .cancel, action: .send(dismissAction)) {
              TextState("Dismiss")
            }
        }, message: {
            TextState(body)
        })
    }

    // MARK: - State
    public struct FlowState {
        var flow: Flow?
        var rememberDetails: Bool
        var email: String?
        var phoneNumber: String?
        var enteredCode: String?
        var expectedCode: String?

        public init(flow: OnboardingFlowModel.FlowState.Flow? = nil, rememberDetails: Bool = false, email: String? = nil, phoneNumber: String? = nil, enteredCode: String? = nil, expectedCode: String? = nil) {
            self.flow = flow
            self.rememberDetails = rememberDetails
            self.email = email
            self.phoneNumber = phoneNumber
            self.enteredCode = enteredCode
            self.expectedCode = expectedCode
        }

        public enum Flow {
            case signIn, signUp
        }
    }

    public enum OnboardingAction {
        case complete
    }
}
