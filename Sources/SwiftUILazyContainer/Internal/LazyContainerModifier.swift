/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyContainerModifier: AnimatableModifier {
    private var insets: EdgeInsets
    private var safeAreaFactors: EdgeInsets
    
    init(padding: CGFloat, safeAreaEdges: Edge.Set) {
        self.insets = EdgeInsets(
            top: padding,
            leading: padding,
            bottom: padding,
            trailing: padding
        )
        self.safeAreaFactors = EdgeInsets(
            top: safeAreaEdges.contains(.top) ? 1 : 0,
            leading: safeAreaEdges.contains(.leading) ? 1 : 0,
            bottom: safeAreaEdges.contains(.bottom) ? 1 : 0,
            trailing: safeAreaEdges.contains(.trailing) ? 1 : 0
        )
    }
    
    init(insets: EdgeInsets, safeAreaEdges: Edge.Set) {
        self.insets = insets
        self.safeAreaFactors = EdgeInsets(
            top: safeAreaEdges.contains(.top) ? 1 : 0,
            leading: safeAreaEdges.contains(.leading) ? 1 : 0,
            bottom: safeAreaEdges.contains(.bottom) ? 1 : 0,
            trailing: safeAreaEdges.contains(.trailing) ? 1 : 0
        )
    }
    
    var animatableData: AnimatablePair<EdgeInsets.AnimatableData, EdgeInsets.AnimatableData> {
        get {
            AnimatablePair(insets.animatableData, safeAreaFactors.animatableData)
        }
        set {
            insets.animatableData = newValue.first
            safeAreaFactors.animatableData = newValue.second
        }
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .environment(\.lazyContainerSize, geometry.size)
                .environment(\.lazyContainerRenderFrame, renderFrame(for: geometry))
        }
    }
    
    private func renderFrame(for geometry: GeometryProxy) -> CGRect {
        let safeArea = EdgeInsets(
            top: geometry.safeAreaInsets.top * safeAreaFactors.top,
            leading: geometry.safeAreaInsets.leading * safeAreaFactors.leading,
            bottom: geometry.safeAreaInsets.bottom * safeAreaFactors.bottom,
            trailing: geometry.safeAreaInsets.trailing * safeAreaFactors.trailing
        )
        
        var frame = geometry.frame(in: .global)
        
        frame.size.width += safeArea.leading + safeArea.trailing + insets.leading + insets.trailing
        frame.size.height += safeArea.top + safeArea.bottom + insets.top + insets.bottom
        frame.origin.x -= (safeArea.leading + insets.leading)
        frame.origin.y -= (safeArea.top + insets.top)
        
        return frame
    }
}
