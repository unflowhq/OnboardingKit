//
//  NotificationPermissionPage.swift
//  
//
//  Created by Alex Logan on 31/01/2023.
//

import SwiftUI

struct NotificationPermissionPage: View {
    var handler: (Action) async -> (NotificationPermissionPage.ActionResult)

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Spacing.compactStack) {
            Header(text: "Don't miss anything", image: "LadyWithBag")
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.compactStack) {
                Text("Get full control over your purchases, allow push notifications and get information when you have made a purchase or when you have something to pay.")
                    .typeStyle(.body)
            }
            Spacer()
            VStack(spacing: DesignConstants.Spacing.compactStack) {
                MinimalButton(
                    text: "Sure!",
                    style: .primary,
                    prominence: .regular,
                    action: {
                        Task {
                            await handler(.requestPermissions)
                        }
                    }
                )
                MinimalButton(
                    text: "Not right now",
                    style: .secondary,
                    prominence: .reduced,
                    action: {
                        Task {
                            await handler(.skip)
                        }
                    }
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    Task {
                        await handler(.skip)
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.subheadline.weight(.semibold))
                })
            })
        })
    }

    enum Action {
        case requestPermissions, skip
    }

    enum ActionResult {
        // All actions simply push to the next page.
        case none
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    private struct Preview: View {
        var body: some View {
            NavigationStack {
                MinimalThemeContainer {
                    NotificationPermissionPage(handler: handle(action:))
                }
            }
        }

        func handle(action: NotificationPermissionPage.Action) async -> NotificationPermissionPage.ActionResult {
            return .none
        }
    }
}
