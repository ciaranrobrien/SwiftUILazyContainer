//
//  SwiftUIView.swift
//  
//
//  Created by Ciaran O'Brien on 29/04/2024.
//

import SwiftUI

internal enum LazyContentTemplateAnchor {
    case empty
    case resolved(Anchor<CGRect>)
}


internal struct LazyContentTemplateAnchorsKey: PreferenceKey {
    typealias Value = [AnyHashable? : LazyContentTemplateAnchor]
    
    static let defaultValue: Value = [:]
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}
