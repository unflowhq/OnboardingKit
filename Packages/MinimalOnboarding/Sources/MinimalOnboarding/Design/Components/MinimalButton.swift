//
//  MinimalButton.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

struct MinimalButton: View {
    let text: String
    let style: MinimalButton.Style
    let prominence: MinimalButton.Prominence
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(text)
        })
        .buttonStyle(MinimalButtonStyle(style: style, prominence: prominence))
    }

    enum Style {
        case primary, secondary

        var backgroundColor: Color {
            switch self {
            case .primary:
                return .text
            case .secondary:
                return .clear
            }
        }

        var textColor: Color {
            switch self {
            case .primary:
                return .primaryBackground
            case .secondary:
                return .text
            }
        }
    }

    enum Prominence {
        case regular, reduced

        var height: CGFloat {
            switch self {
            case .regular:
                return 56
            case .reduced:
                return 24
            }
        }
    }
}

private struct MinimalButtonStyle: ButtonStyle {
    let style: MinimalButton.Style
    let prominence: MinimalButton.Prominence

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typeStyle(.button)
            .foregroundColor(style.textColor)
            .lineLimit(1)
            .padding(
                prominence == .regular ? 16 : 0
            )
            .frame(
                maxWidth: .infinity,
                minHeight: prominence.height,
                alignment: .center
            )
            .background(
                Rectangle()
                    .foregroundColor(style.backgroundColor)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct MinimalButton_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            VStack(spacing: DesignConstants.Spacing.compactStack) {
                MinimalButton(
                    text: "Primary", style: .primary, prominence: .regular, action: {}
                )
                MinimalButton(
                    text: "Secondary", style: .secondary, prominence: .regular, action: {}
                )
                MinimalButton(
                    text: "Primary - Reduced", style: .primary, prominence: .reduced, action: {}
                )
                MinimalButton(
                    text: "Secondary - Reduced", style: .secondary, prominence: .reduced, action: {}
                )
            }
            .padding()
        }
    }
}
