/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine
import SwiftUI

internal struct LengthReader<Content>: View
where Content : View
{
    @State private var length: Double? = nil
    private var axis: Axis
    private var content: (Double?) -> Content
    
    init(_ axis: Axis, @ViewBuilder content: @escaping (Double?) -> Content) {
        self.axis = axis
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                let newValue = switch axis {
                case .horizontal: geometry.size.width
                case .vertical: geometry.size.height
                }
                
                Color.clear
                    .onReceive(Just(newValue)) { newValue in
                        if length != newValue {
                            length = newValue
                        }
                    }
            }
            .frame(
                width: axis == .vertical ? 0 : nil,
                height: axis == .horizontal ? 0 : nil
            )
            .hidden()
            
            content(length)
        }
    }
}
