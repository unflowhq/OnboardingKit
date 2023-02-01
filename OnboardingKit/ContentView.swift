//
//  ContentView.swift
//  OnboardingKit
//
//  Created by Alex Logan on 30/01/2023.
//

import SwiftUI
import MinimalOnboarding
import SwiftUINavigation

struct ContentView: View {
    @State private var flow: Flow?

    var listRowBackgroundColor: Color {
        Color("DynamicWhite")
    }

    var body: some View {
        NavigationStack {
            List {
                Image("Header")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .listRowInsets(EdgeInsets())

                Section(header: Text("Unflow")) {
                    Text("OnboardingKit is brought to you by Unflow. Unflow is a next-generation mobile CMS that allows you to set gorgeous native screens live remotley with no need for developer intervention.")
                    urlButton(url: "https://unflow.com/onboarding", text: "Check out Unflow")
                    urlButton(url: "https://www.figma.com/community/file/1197544767192716804", text: "OnboardingKit on Figma")
                }
                .listRowBackground(listRowBackgroundColor)

                Section(header: Text("Demo")) {
                    Text("Select a flow to preview the full onboarding experience.")
                    Text("Flows are designed to emulate how they'd behave for real, so you can only exit at points where you'd typically exit.")
                }
                .listRowBackground(listRowBackgroundColor)

                Section(header: Text("Flows"), footer: Text("More flows are coming soon.")) {
                    Button(action: {
                        self.flow = .minimal
                    }, label: {
                        Text("Minimal Flow")
                    })
                }
                .listRowBackground(listRowBackgroundColor)

                Section(footer: Text("Made with ❤️ and lots of ☕️ by @SwiftyAlex").fontWeight(.bold)) { EmptyView() }
            }
            .listRowBackground(listRowBackgroundColor)
            .navigationTitle("OnboardingKit")
            .fullScreenCover(unwrapping: $flow) { flow in
                switch flow.wrappedValue {
                case .minimal:
                    OnboardingFlow(flowModel: .init(handler: { _ in
                        self.flow = nil
                    }))
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                Color("BackgroundGrey").edgesIgnoringSafeArea(.all)
            )
        }
    }

    private func urlButton(url: String, text: String) -> some View {
        Button(action: {
            guard let url = URL(string: url) else { return }
            UIApplication.shared.open(url)
        }, label: {
            Text(text)
        })
    }
}

private enum Flow {
    case minimal
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
