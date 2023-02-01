# MinimalOnboarding

![MinimalOnboarding](/Github/MinimalOnboarding.png)

Minimal onboarding is based on our clean template from [OnboardingKit](https://www.figma.com/community/file/1197544767192716804).

There's two flows, login and signup. When you login, you're just prompted to add your phone number, then give notification permissions. 

For signup, you're asked to provide email first ( and verify it ), then you get some extra promotional materials with placeholder text.

## Architecture

The architecture is a simple redux-ish design, with some exceptions to help with portability of these screens. There's one model `OnboardingFlowModel` that maintains state and the navigation path.

All pages pass back their actions to the model, which in turn updates its own state and returns a result. 

The types for each pages actions and results are unique, and could be flattened if you choose to use a TCA style design. 

Each page gets provided initial state from the model, but generally hosts this initial state inside a `State` modifier. 
This is to aid in portability if you choose to not use this architecture here and just lift individual screens.

## How to use

You'll need the links to be setup in your info.plist for email validation to work. Specifically, this uses "minimal-onboarding://email-verified?email=email@email.com" as the verification technique.

If you're looking to test this, you can use the terminal command `xcrun simctl openurl booted 'minimal-onboarding://email-verification?email=email@email.com'.

Throughout the package are small `// Task:` markers. These highlight any placeholders where you should implement real functionality instead of placeholders.


## Acknowledgements

The drawings are from the Nankin pack on [storytale](https://storytale.io/pack/348). If you want to use these templates, you'll need to make sure you have access to them.

Inside the app, we use some of the alert functionality from [SwiftUI-Navigation](https://github.com/pointfreeco/swiftui-navigation) by [PointFree](https://www.pointfree.co).
