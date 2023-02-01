//
//  OnboardingFlow.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

public struct OnboardingFlow: View {
    @StateObject var flowModel: OnboardingFlowModel

    public init(
        flowModel: OnboardingFlowModel
    ) {
        self._flowModel = StateObject(wrappedValue: flowModel)
    }

    public var body: some View {
        MinimalThemeContainer {
            NavigationStack(path: $flowModel.path) {
                IntroPage(actionHandler: flowModel.handleIntroActions(action:))
                    .applyNavigationDestinations()
            }
        }
        .environmentObject(flowModel)
        .onOpenURL(perform: flowModel.handle(url:))
    }
}


// MARK: - NavigationStack helper
struct FlowNavigationModifier: ViewModifier {
    @EnvironmentObject var flowModel: OnboardingFlowModel

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Screen.self, destination: { screen in
                switch screen {
                case .signUp:
                    EmailPage(
                        email: flowModel.state.email ?? "",
                        toggleOn: flowModel.state.rememberDetails,
                        actionHandler: flowModel.handleEmailActions(action:)
                    )
                case .signIn, .phoneNumberEntry:
                    PhoneNumberEntryPage(
                        phoneNumber: flowModel.state.phoneNumber ?? "",
                        actionHandler: flowModel.handlePhoneActions(action:)
                    )
                case .emailVerification:
                    ConfirmEmailPage(
                        email: flowModel.state.email ?? ""
                    )
                case .intro:
                    IntroPage(actionHandler: flowModel.handleIntroActions(action:))
                case .promotion:
                    PromotionPage(actionHandler: flowModel.handlePromoAction(action:))
                case .phoneNumberVerification:
                    ConfirmationCodePage(
                        phoneNumber: flowModel.state.phoneNumber ?? "",
                        code: flowModel.state.enteredCode ?? "",
                        actionHandler: flowModel.handleConfirmationCodeActions(action:)
                    )
                case .phoneConfirmed:
                    SetupConfirmationPage(handler: flowModel.handleSetupConfirmationActions(action:))
                case .notifications:
                    NotificationPermissionPage(handler: flowModel.handleNotificationActions(action:))
                }
            })
    }
}

extension View {
    func applyNavigationDestinations() -> some View {
        self
            .modifier(FlowNavigationModifier())
    }
}

private struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow(
            flowModel: OnboardingFlowModel(
                path: [.signIn, .signUp, .emailVerification], handler: {
                    _ in
                }
            )
        )
    }
}
