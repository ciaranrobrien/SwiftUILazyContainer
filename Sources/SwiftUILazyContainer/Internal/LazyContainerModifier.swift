/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyContainerModifier<Templates>: AnimatableModifier
where Templates : View
{
    private var insets: EdgeInsets
    private var safeAreaFactors: EdgeInsets
    private var templates: () -> Templates
    
    init(padding: Double, safeAreaEdges: Edge.Set, templates: @escaping () -> Templates) {
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
        self.templates = templates
    }
    
    init(insets: EdgeInsets, safeAreaEdges: Edge.Set, templates: @escaping () -> Templates) {
        self.insets = insets
        self.safeAreaFactors = EdgeInsets(
            top: safeAreaEdges.contains(.top) ? 1 : 0,
            leading: safeAreaEdges.contains(.leading) ? 1 : 0,
            bottom: safeAreaEdges.contains(.bottom) ? 1 : 0,
            trailing: safeAreaEdges.contains(.trailing) ? 1 : 0
        )
        self.templates = templates
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
            ZStack {
                templates()
                    .fixedSize()
                    // ProMotion max frame rate animations on resize.
                    .background(
                        GeometryReader { geometry in
                            Text(verbatim: "I")
                                .offset(
                                    x: min(geometry.size.width * 999, .greatestFiniteMagnitude),
                                    y: min(geometry.size.height * 999, .greatestFiniteMagnitude)
                                )
                        }
                    )
                    // ProMotion max frame rate animations on insert and remove.
                    .transition(.offset(x: 999_999, y: 999_999))
            }
            .hidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .overlayPreferenceValue(LazySubviewTemplateAnchorsKey.self) { anchors in
                let sizes = anchors.mapValues { geometry[$0].size }
                
                content
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .environment(\.lazyContainerSize, geometry.size)
                    .environment(\.lazyContainerRenderFrame, renderFrame(for: geometry))
                    .environment(\.lazySubviewTemplateSizes, sizes)
            }
            .transformPreference(LazySubviewTemplateAnchorsKey.self) { $0.removeAll() }
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
