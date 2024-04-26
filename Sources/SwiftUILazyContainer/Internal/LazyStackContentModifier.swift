/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackContentModifier: AnimatableModifier {
    var stackLength: CGFloat
    var stackOrigin: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(stackLength, stackOrigin)
        } set {
            stackLength = newValue.first
            stackOrigin = newValue.second
        }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.lazyStackGeometry, animatableData)
    }
}
