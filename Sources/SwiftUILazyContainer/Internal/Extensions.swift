/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension CGFloat {
    static let defaultSpacing: Self = 8
}


internal extension EnvironmentValues {
    var lazyContainerFrame: CGRect? {
        get { self[LazyContainerFrameKey.self] }
        set { self[LazyContainerFrameKey.self] = newValue }
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


private struct LazyContainerFrameKey: EnvironmentKey {
    static let defaultValue: CGRect? = nil
}
private struct LazyContentTemplateSizesKey: EnvironmentKey {
    static let defaultValue = [AnyHashable? : CGSize]()
}
private struct LazyStackGeometryKey: EnvironmentKey {
    static let defaultValue = AnimatablePair<CGFloat, CGFloat>(.zero, .zero)
}
