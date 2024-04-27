/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension CGFloat {
    static let defaultSpacing: Self = 8
}


internal extension LazyContentAnchor {
    enum Source: Equatable {
        case fixed(Value)
        case fraction(Value)
        case template(AnyHashable?)
    }
}


internal extension EnvironmentValues {
    var lazyContainerRenderFrame: CGRect? {
        get { self[LazyContainerRenderFrameKey.self] }
        set { self[LazyContainerRenderFrameKey.self] = newValue }
    }
    var lazyContainerSize: CGSize? {
        get { self[LazyContainerSizeKey.self] }
        set { self[LazyContainerSizeKey.self] = newValue }
    }
    var lazyContentTemplateSizes: [AnyHashable? : CGSize] {
        get { self[LazyContentTemplateSizesKey.self] }
        set { self[LazyContentTemplateSizesKey.self] = newValue }
    }
    var lazyStackGeometry: AnimatablePair<CGFloat, CGFloat> {
        get { self[LazyStackGeometryKey.self] }
        set { self[LazyStackGeometryKey.self] = newValue }
    }
}


private struct LazyContainerRenderFrameKey: EnvironmentKey {
    static let defaultValue: CGRect? = nil
}
private struct LazyContainerSizeKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}
private struct LazyContentTemplateSizesKey: EnvironmentKey {
    static let defaultValue = [AnyHashable? : CGSize]()
}
private struct LazyStackGeometryKey: EnvironmentKey {
    static let defaultValue = AnimatablePair<CGFloat, CGFloat>(.zero, .zero)
}
