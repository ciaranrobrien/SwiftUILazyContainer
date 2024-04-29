/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import enum Accelerate.vDSP

extension Array<Double>: AdditiveArithmetic, Animatable, VectorArithmetic {
    public static var zero: Self = [.zero]

    public static func + (lhs: [Double], rhs: [Double]) -> [Double] {
        let count = Swift.min(lhs.count, rhs.count)
        return vDSP.add(lhs[0..<count], rhs[0..<count])
    }

    public static func += (lhs: inout [Double], rhs: [Double]) {
        let count = Swift.min(lhs.count, rhs.count)
        vDSP.add(lhs[0..<count], rhs[0..<count], result: &lhs[0..<count])
    }

    public static func - (lhs: [Double], rhs: [Double]) -> [Double] {
        let count = Swift.min(lhs.count, rhs.count)
        return vDSP.subtract(lhs[0..<count], rhs[0..<count])
    }

    public static func -= (lhs: inout [Double], rhs: [Double]) {
        let count = Swift.min(lhs.count, rhs.count)
        vDSP.subtract(lhs[0..<count], rhs[0..<count], result: &lhs[0..<count])
    }

    public mutating func scale(by rhs: Double) {
        self = vDSP.multiply(rhs, self)
    }

    public var magnitudeSquared: Double {
        vDSP.sum(vDSP.multiply(self, self))
    }
}


extension Double: Animatable { }


internal extension CGFloat {
    static let defaultSpacing: Self = 8
}


internal extension LazyContentAnchor {
    enum Source: Equatable {
        case fixed(Value)
        case fraction(Value)
        case template(AnyHashable?)
    }
    
    func resolve(axis: Axis, containerSize: CGSize, templates: [AnyHashable? : CGSize]) -> Double
    where Value == CGFloat
    {
        sources.reduce(Double.zero) { length, source in
            let nextLength: Double = switch source {
            case .fixed(let length):
                length
            case .fraction(let fraction):
                switch axis {
                case .horizontal: containerSize.width * fraction
                case .vertical: containerSize.height * fraction
                }
            case .template(let id):
                if let size = templates[id] {
                    switch axis {
                    case .horizontal: size.width
                    case .vertical: size.height
                    }
                } else {
                    .zero
                }
            }
            
            return length + nextLength
        }
    }
    
    func resolve(containerSize: CGSize, templates: [AnyHashable? : CGSize]) -> CGSize
    where Value == CGSize
    {
        sources.reduce(into: CGSize.zero) { size, source in
            switch source {
            case .fixed(let length):
                size.width += length.width
                size.height += length.height
            case .fraction(let fraction):
                size.width += containerSize.width * fraction.width
                size.height += containerSize.height * fraction.height
            case .template(let id):
                let template = templates[id] ?? .zero
                size.width += template.width
                size.height += template.height
            }
        }
    }
}


internal extension EnvironmentValues {
    var lazyContainerRenderFrame: CGRect? {
        get { self[LazyContainerRenderFrameKey.self] }
        set { self[LazyContainerRenderFrameKey.self] = newValue }
    }
    var lazyContainerSize: CGSize? {
        get { self[LazyContainerSizeKey.self] }
        set { self[LazyContainerSizeKey.self] = newValue }
    }
    var lazyContentLengths: [Double] {
        get { self[LazyContentLengthsKey.self] }
        set { self[LazyContentLengthsKey.self] = newValue }
    }
    var lazyContentTemplateSizes: [AnyHashable? : CGSize] {
        get { self[LazyContentTemplateSizesKey.self] }
        set { self[LazyContentTemplateSizesKey.self] = newValue }
    }
    
    var lazyLayoutOrigin: Double {
        get { self[LazyLayoutOriginKey.self] }
        set { self[LazyLayoutOriginKey.self] = newValue }
    }
    var lazyLayoutSize: CGSize {
        get { self[LazyLayoutSizeKey.self] }
        set { self[LazyLayoutSizeKey.self] = newValue }
    }
    
    var lazyMasonryElementLengths: [Double] {
        get { self[LazyMasonryElementLengthsKey.self] }
        set { self[LazyMasonryElementLengthsKey.self] = newValue }
    }
    var lazyMasonryElementOffsets: [Double] {
        get { self[LazyMasonryElementOffsetsKey.self] }
        set { self[LazyMasonryElementOffsetsKey.self] = newValue }
    }
    var lazyMasonryElementVectors: [Double] {
        get { self[LazyMasonryElementVectorsKey.self] }
        set { self[LazyMasonryElementVectorsKey.self] = newValue }
    }
}


private struct LazyContainerRenderFrameKey: EnvironmentKey {
    static let defaultValue: CGRect? = nil
}
private struct LazyContainerSizeKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}
private struct LazyContentLengthsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazyContentTemplateSizesKey: EnvironmentKey {
    static let defaultValue = [AnyHashable? : CGSize]()
}

private struct LazyLayoutOriginKey: EnvironmentKey {
    static let defaultValue = Double.zero
}
private struct LazyLayoutSizeKey: EnvironmentKey {
    static let defaultValue = CGSize.zero
}

private struct LazyMasonryElementLengthsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazyMasonryElementOffsetsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazyMasonryElementVectorsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
