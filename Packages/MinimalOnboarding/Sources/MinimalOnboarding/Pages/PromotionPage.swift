//
//  PromotionController.swift
//  
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI

struct PromotionPage: View {
    let actionHandler: ((PromotionPage.Action) -> Void)
    var items: [PromotionItem] = PromotionItem.all

    @State var index: Int = 0

    var body: some View {
        VStack(spacing: DesignConstants.Spacing.compactStack) {
            TabView(selection: $index) {
                ForEach(Array(items.enumerated()), id: \.offset) { item in
                    PromotionPageElement(item: item.element)
                        .tag(item.offset)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default so we can control the position exactly
            // NB: We can't ignore the safe area like the design due to a bug it causes with layout in iOS 16.
            // You will get a bunch of errors to do with collection view layouts, which TabView with PageTabViewStyle uses under the hood.
            // To re-create, uncomment either of these lines, and scroll.
            // If a solution is found for this, a PR would be welcome :)
            // .edgesIgnoringSafeArea(.top)
            // .ignoresSafeArea(.container, edges: .top)
            .padding(.bottom, DesignConstants.Spacing.compactStack)

            PageControl(numberOfPages: items.count, currentPage: $index)

            MinimalButton(
                text: index == (items.endIndex-1) ? "Done" : "Next",
                style: .primary,
                prominence: .regular,
                action: increment
            )
            .padding()
        }
        .animation(.interactiveSpring(), value: index)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func increment() {
        if index < (items.endIndex-1) {
            index += 1
        } else {
            actionHandler(.complete)
        }
    }

    enum Action {
        case complete
    }
}

/// Replace your promotion items with real content
struct PromotionItem {
    let title: String
    let text: String
    let imageName: String

    static let all = [one, two]
    static let one: PromotionItem = .init(title: "Lorem ipsum dolor sit amet", text: "Lorem ipsum dolor sit amet consectetur. Amet massa duis pellentesque eu.", imageName: "PromotionImageOne")
    static let two: PromotionItem = .init(title: "Lorem ipsum dolor sit amet", text: "Lorem ipsum dolor sit amet consectetur. Amet massa duis pellentesque eu.", imageName: "PromotionImageTwo")
}

private struct PromotionPageElement: View {
    let item: PromotionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxHeight: .infinity, alignment: .center)
                .background(
                    Image(uiImage: .fromPackage(named: item.imageName))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipped()

            VStack(alignment: .leading, spacing: DesignConstants.Spacing.extraCompactStack) {
                Text(item.title)
                    .font(MinimalFont.Manrope.extraBold.font(size: 24, relativeTo: .title))
                Text(item.text)
                    .typeStyle(.body)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.pageIndicatorTintColor = UIColor.secondaryLabel
        control.currentPageIndicatorTintColor = UIColor.label

        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged
        )

        return control
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }

    class Coordinator: NSObject {
        var control: PageControl

        init(_ control: PageControl) {
            self.control = control
        }
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

struct PromotionController_Previews: PreviewProvider {
    static var previews: some View {
        MinimalThemeContainer {
            PromotionPage(actionHandler: { _ in })
        }
    }
}
