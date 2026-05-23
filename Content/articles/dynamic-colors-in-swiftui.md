---
title: Dynamic Colors in SwiftUI
tags: swiftui, tips-and-tricks
summary: In which we resolve colors at runtime.
publish_date: 2026-05-23
---

If you've been working in SwiftUI long enough, then you've probably wanted the ability to create a color at runtime that varies depending on if the user has their device in dark mode or light mode. Maybe you're consuming content from an API that provides colors for both modes, or maybe you're taking one color to use for one mode and transforming it in some way to get another color to use for the other mode. Regardless of why you're doing it, you're in a situation where using an asset catalog or some other mechanism for defining your colors up front doesn't work for you.

Fortunately, UIKit and AppKit both have your back in this situation. Both UI frameworks have API on their respective color types that allow you to inspect the environment the color is used in, detect whether light or dark mode is being used, and resolve a color to use at runtime. Surprisingly, though, no equivalent initializer exists in SwiftUI. However, because we can go from a SwiftUI `Color` to a UIKit `UIColor` or AppKit `NSColor` and back again, we can leverage the other UI frameworks to dynamically resolve a color and then give that resolved color to SwiftUI to use. Maybe you've written an extension that does this, something along these lines:

```swift
extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        }))
    }
}
```

This works. There's nothing really wrong with it. This is part of the point of the SwiftUI API, to give us these escape hatches when we need to use them because the SwiftUI API surface has some gap. Fortunately, this gap was addressed in iOS 17 and macOS 14. Starting with these OS versions, SwiftUI added new requirements to the `ShapeStyle` protocol (which `Color`, among other things, conforms to):

```swift
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ShapeStyle : Sendable {

    /// The type of shape style this will resolve to.
    ///
    /// When you create a custom shape style, Swift infers this type
    /// from your implementation of the required `resolve` function.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    associatedtype Resolved : ShapeStyle = Never

    /// Evaluate to a resolved shape style given the current `environment`.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    func resolve(in environment: EnvironmentValues) -> Self.Resolved
}
```

While `ShapeStyle` previously was a public protocol that we could conform our own type to, there weren't any requirements. That is, there weren't any hooks that SwiftUI could call on our type to do something with it. So, prior to iOS 17 and macOS 14, it didn't really make much sense to create a custom type that conformed to `ShapeStyle`.

But with these new requirements, now there are hooks that we can implement that SwiftUI can call into and do something with our custom shape style. These requirements look similar to `UIColor`'s and `NSColor`'s initializers: we're given some input we can query and then return a color depending on that input. Since we receive a SwiftUI environment when our `resolve` method is called, we can query its color scheme to determine if we're in light mode or dark mode, and return an appropriate color.

```swift
struct DynamicColor: ShapeStyle {
    let light: Color
    let dark: Color
    
    func resolve(in environment: EnvironmentValues) -> Color {
        return environment.colorScheme == .dark ? dark : light
    }
}

extension ShapeStyle where Self == DynamicColor {
    static func dynamic(light: Color, dark: Color) -> DynamicColor {
        DynamicColor(light: light, dark: dark)
    }
}
```

With this custom shape style in place, we can dynamically resolve colors at runtime without needing to fallback to other UI frameworks _and_ it works in all the places where `Color` or any other `ShapeStyle`-conforming type would work. While a bit contrived, the following code sample showcases how we can use `DynamicColor` to change the background color of a view hierarchy depending on if the user is using light or dark mode:

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .background(.dynamic(light: Color.orange, dark: Color.pink))
    }
}
```

<div class="flex justify-center gap-x-3 w-full">
  <img src="/img/articles/dynamic-colors-in-swiftui/light-appearance.png" alt="The text 'Hello, world!' with a globe icon stacked above it. Both are layered on top of an orange background, as this is a screenshot from an app running in light mode, and the dynamic color resolves to orange in light mode.">
  <img src="/img/articles/dynamic-colors-in-swiftui/dark-appearance.png" alt="The text 'Hello, world!' with a globe icon stacked above it. Both are layered on top of an pink background, as this is a screenshot from an app running in dark mode, and the dynamic color resolves to pink in dark mode.">
</div>

In the situation that we do need to use a `Color` some place, we can leverage this initializer on `Color`:

```swift
@frozen public struct Color : Hashable, CustomStringConvertible, Sendable {

    /// Creates a color that represents the specified custom color.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public init<T>(_ color: T) where T : Hashable, T : ShapeStyle, T.Resolved == Color.Resolved

}
```

With a few tweaks to `DynamicColor` to make it `Hashable` and to return `Color.Resolved` instead of `Color`, we can pass an instance to this initializer to create a `Color` from it:

```swift
struct DynamicColor: ShapeStyle, Hashable {
    let light: Color
    let dark: Color
   
    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        return environment.colorScheme == .dark
            ? dark.resolve(in: environment)
            : light.resolve(in: environment)
    }
}

extension Color {
    static func dynamic(light: Color, dark: Color) -> Color {
        .init(DynamicColor(light: light, dark: dark))
    }
}
```

And with that, everything is in place to let us vary a color depending on whether the user is using light or dark mode in a cross-platform way that doesn't rely on falling back to other UI frameworks.
