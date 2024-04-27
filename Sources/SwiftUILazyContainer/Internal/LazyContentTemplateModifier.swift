/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct LazyContentTemplateModifier<TemplateContent>: ViewModifier
where TemplateContent : View
{
    var axes: Axis.Set
    var id: AnyHashable?
    var templateContent: () -> TemplateContent
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(content: templateContent)
                .hidden()
                .fixedSize(
                    horizontal: axes.contains(.horizontal),
                    vertical: axes.contains(.vertical)
                )
                .overlay(
                    GeometryReader { templateGeometry in
                        content
                            .transformEnvironment(\.lazyContentTemplateSizes) { templateSizes in
                                templateSizes[id] = templateGeometry.size
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }, alignment: .topLeading
                )
        }
    }
}
