# SwiftUI LazyContainer

Lazy rendering and layouts in a SwiftUI ScrollView.

If existing SwiftUI rendering and layouts are performant for your app, use (https://github.com/ciaranrobrien/SwiftUIOnVisible)[SwiftUIOnVisible] instead for callbacks when views become visible in a ScrollView.

## Get Started

Use `lazyContainer` to configure the scroll view for lazy rendering.

Use `AltLazyVStack` as a replacement for `VStack` or `LazyVStack` to only render its content when visible in the scroll view.

```swift
    ScrollView {
        AltLazyVStack(data, contentHeight: 200) { element in
            /// Lazy content
        }
    }
    .lazyContainer()
}
```

## Advanced Usage

Use `LazyVContent` for lazy rendering in an existing SwiftUI layout. Note that, when used frequently,`LazyVContent` can impact scroll performance.

Use `fraction` to fix lazy content height at a fraction of the lazy container's height.

```swift
private struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<100) { number in
                    LazyVContent(height: .fraction(1/3)) {
                        /// Lazy content
                    }
                }
            }
        }
        .lazyContainer()
    }
}
```

Use `lazyContentTemplate` to provide a hidden template view to size lazy content.

```swift
private struct ContentView: View {
    var data: [FooElement]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<3) { number in
                    /// Non-lazy content
                }
                
                AltLazyVStack(data, contentHeight: .template) { element in
                    /// Lazy content
                }
            }
        }
        .lazyContainer(renderingPadding: 16, rendersInSafeAreaEdges: .all) {
            VStack {
                Text(verbatim: "Placeholder")
                    .font(.headline)
                
                Text(verbatim: "Placeholder")
                    .font(.subheadline)
            }
            .lineLimit(1)
            .lazyContentTemplate()
        }
    }
}
```

See [Examples](/Sources/SwiftUILazyContainer/Examples/) for more.

## Requirements

* iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+, visionOS 1.0+
* Xcode 15.0+

## Installation

* Install with [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
* Import `SwiftUILazyContainer` to start using.

## Contact

[@ciaranrobrien](https://twitter.com/ciaranrobrien) on Twitter.
