# SwiftUI LazyContainer

Lazy rendering and layouts in a SwiftUI ScrollView.

For existing SwiftUI layouts, consider [SwiftUIOnVisible](https://github.com/ciaranrobrien/SwiftUIOnVisible) instead to get callbacks when subviews become visible in a ScrollView.

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
```

Use `LazyVMasonry` to arrange subviews in a vertical masonry with lazy rendering.

Use `renderingPadding` and `rendersInSafeAreaEdges` to control how far away from the container's edges subviews are rendered.

```swift
ScrollView {
    LazyVMasonry(data, columns: 2, contentHeights: [.fraction(1/4), .fraction(1/5)]) { element in
        /// Lazy content
    }
}
.lazyContainer(renderingPadding: 16, rendersInSafeAreaEdges: .all)
```

## Advanced Usage

Use `template` and `lazySubviewTemplate` to provide hidden template views for sizing lazy subviews.

```swift
ScrollView {
    VStack {
        AltLazyVStack(data, contentHeight: .template) { element in
            /// Lazy content
        }
    }
}
.lazyContainer {
    VStack {
        Text(verbatim: "Placeholder")
            .font(.headline)
        
        Text(verbatim: "Placeholder")
            .font(.subheadline)
    }
    .padding()
    .lineLimit(1)
    .lazySubviewTemplate()
}
```

Use the `contentHeight` closure to resolve subview heights for each element. Combine `LazySubviewSize` values with `+` or `sum` to build subview heights from multiple anchors.

```swift
ScrollView {
    LazyVMasonry(data, columns: .adaptive(minSize: 140), spacing: 8) { element in
        /// Lazy content
    } contentHeight: { element in
        let imageAnchor = LazySubviewSize.aspect(element.imageSize.width / element.imageSize.height)
        let titleAnchor = LazySubviewSize.template(id: element.subtitle == nil ? 1 : 2)
        return imageAnchor + titleAnchor
    }
}
.lazyContainer {
    Text(verbatim: "Title Placeholder")
        .font(.headline)
        .padding()
        .lineLimit(1)
        .lazySubviewTemplate(id: 1)
    
    VStack {
        Text(verbatim: "Title Placeholder")
            .font(.headline)
        
        Text(verbatim: "Subtitle Placeholder")
            .font(.subheadline)
    }
    .padding()
    .lineLimit(1)
    .lazySubviewTemplate(id: 2)
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
