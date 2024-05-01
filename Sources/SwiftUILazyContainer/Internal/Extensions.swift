/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine
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


internal extension Axis {
    var orthogonal: Self {
        switch self {
        case .horizontal: .vertical
        case .vertical: .horizontal
        }
    }
}


internal extension LazySubviewSize {
    enum Source: Equatable {
        case aspect(Double)
        case fixed(Double)
        case fraction(Double)
        case template(AnyHashable?)
    }
    
    func resolve(axis: Axis, breadth: Double, containerLength: Double, templates: [AnyHashable? : CGSize]) -> Double {
        sources.reduce(Double.zero) { length, source in
            let nextLength: Double = switch source {
            case .aspect(let ratio):
                switch axis {
                case .horizontal: breadth * ratio
                case .vertical: breadth / ratio
                }
            case .fixed(let length):
                length
            case .fraction(let fraction):
                containerLength * fraction
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
}


internal extension EnvironmentValues {
    var _resolvedLazySubviewSize: CGSize {
        get { self[ResolvedLazySubviewSizeKey.self] }
        set { self[ResolvedLazySubviewSizeKey.self] = newValue }
    }
    
    var lazyContainerRenderFrame: CGRect? {
        get { self[LazyContainerRenderFrameKey.self] }
        set { self[LazyContainerRenderFrameKey.self] = newValue }
    }
    var lazyContainerSize: CGSize? {
        get { self[LazyContainerSizeKey.self] }
        set { self[LazyContainerSizeKey.self] = newValue }
    }
    var lazySubviewTemplateSizes: [AnyHashable? : CGSize] {
        get { self[LazyContentTemplateSizesKey.self] }
        set { self[LazyContentTemplateSizesKey.self] = newValue }
    }
    
    var lazyLayoutLength: Double {
        get { self[LazyLayoutLengthKey.self] }
        set { self[LazyLayoutLengthKey.self] = newValue }
    }
    var lazyLayoutLines: Int {
        get { self[LazyLayoutLinesKey.self] }
        set { self[LazyLayoutLinesKey.self] = newValue }
    }
    var lazyLayoutOrigin: Double {
        get { self[LazyLayoutOriginKey.self] }
        set { self[LazyLayoutOriginKey.self] = newValue }
    }
    
    var lazySubviewLengths: [Double] {
        get { self[LazySubviewLengthsKey.self] }
        set { self[LazySubviewLengthsKey.self] = newValue }
    }
    var lazySubviewOffsets: [Double] {
        get { self[LazySubviewOffsetsKey.self] }
        set { self[LazySubviewOffsetsKey.self] = newValue }
    }
    var lazySubviewLineBreadths: [Double] {
        get { self[LazySubviewLineBreadthsKey.self] }
        set { self[LazySubviewLineBreadthsKey.self] = newValue }
    }
    var lazySubviewLineOffsets: [Double] {
        get { self[LazySubviewLineOffsetsKey.self] }
        set { self[LazySubviewLineOffsetsKey.self] = newValue }
    }
}


internal struct LazySubviewTemplateAnchorsKey: PreferenceKey {
    typealias Value = [AnyHashable? : Anchor<CGRect>]
    
    static let defaultValue: Value = [:]
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

private struct ResolvedLazySubviewSizeKey: EnvironmentKey {
    static let defaultValue = CGSize.zero
}

private struct LazyContainerRenderFrameKey: EnvironmentKey {
    static let defaultValue: CGRect? = nil
}
private struct LazyContainerSizeKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}
private struct LazyContentTemplateSizesKey: EnvironmentKey {
    static let defaultValue = [AnyHashable? : CGSize]()
}

private struct LazyLayoutLengthKey: EnvironmentKey {
    static let defaultValue = Double.zero
}
private struct LazyLayoutLinesKey: EnvironmentKey {
    static let defaultValue = Int.zero
}
private struct LazyLayoutOriginKey: EnvironmentKey {
    static let defaultValue = Double.zero
}

private struct LazySubviewLengthsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazySubviewOffsetsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazySubviewLineBreadthsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
private struct LazySubviewLineOffsetsKey: EnvironmentKey {
    static let defaultValue = [Double].zero
}
