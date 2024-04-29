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
    
    var animatableData: Value {
        get { value }
        set { value = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .environment(keyPath, animatableData)
    }
}
