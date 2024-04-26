/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyStackBase<TemplateContent>: View
where TemplateContent : View
{
    var axis: Axis
    var contentLength: CGFloat?
    var dataCount: Int
    var spacing: CGFloat
    var templateContent: (() -> TemplateContent)?
    
    var body: some View {
        if let contentLength {
            Color.clear
                .hidden()
                .frame(
                    width: axis == .horizontal ? stackLength(for: contentLength) : nil,
                    height: axis == .vertical ? stackLength(for: contentLength) : nil
                )
        } else if let templateContent {
            if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, visionOS 1, *) {
                LazyStackBaseLayout(axis: axis, resolveStackLength: stackLength) {
                    switch axis {
                    case .horizontal:
                        HStack(spacing: spacing, content: templateContent)
                    case .vertical:
                        VStack(spacing: spacing, content: templateContent)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .hidden()
            } else {
                LegacyLazyStackBaseLayout(
                    axis: axis,
                    resolveStackLength: stackLength,
                    templateContent: templateContent
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .hidden()
            }
        }
    }
    
    private func stackLength(for contentLength: CGFloat) -> CGFloat {
        if dataCount == .zero {
            .zero
        } else {
            (CGFloat(dataCount) * (contentLength + spacing)) - spacing
        }
    }
}


@available(iOS 16, macOS 13, tvOS 16, watchOS 9, visionOS 1, *)
private struct LazyStackBaseLayout: Layout {
    var axis: Axis
    var resolveStackLength: (CGFloat) -> CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let template = subviews.first
        else { return .zero }
        
        let templateSize = template.sizeThatFits(proposal)
        
        return switch axis {
        case .horizontal:
            CGSize(width: resolveStackLength(templateSize.width), height: templateSize.height)
        case .vertical:
            CGSize(width: templateSize.width, height: resolveStackLength(templateSize.height))
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for subview in subviews {
            subview.place(at: .zero, proposal: proposal)
        }
    }
}


private struct LegacyLazyStackBaseLayout<TemplateContent>: View
where TemplateContent : View
{
    @State private var stackLength: CGFloat? = nil
    
    var axis: Axis
    var resolveStackLength: (CGFloat) -> CGFloat
    var templateContent: () -> TemplateContent
    
    var body: some View {
        templateContent()
            .overlay(
                GeometryReader { geometry in
                    let resolvedStackLength = switch axis {
                    case .horizontal: resolveStackLength(geometry.size.width)
                    case .vertical: resolveStackLength(geometry.size.height)
                    }
                    
                    Color.clear
                        .hidden()
                        .onAppear { stackLength = resolvedStackLength }
                        .onChange(of: resolvedStackLength) { stackLength = $0 }
                }
            )
            .frame(
                width: axis == .horizontal ? stackLength : nil,
                height: axis == .vertical ? stackLength : nil
            )
    }
}
