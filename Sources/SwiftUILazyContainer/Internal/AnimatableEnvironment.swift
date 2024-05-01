/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal struct AnimatableEnvironment<Value>: AnimatableModifier
where Value : Animatable
{
    var keyPath: WritableKeyPath<EnvironmentValues, Value>
    var value: Value
    
    init(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, _ value: Value) {
        self.keyPath = keyPath
        self.value = value
    }
    
    var animatableData: Value.AnimatableData {
        get { value.animatableData }
        set { value.animatableData = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(keyPath, value)
    }
}
