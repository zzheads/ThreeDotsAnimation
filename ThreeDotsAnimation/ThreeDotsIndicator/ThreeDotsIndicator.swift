//
//  ThreeDotsIndicator.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 14.02.2021.
//

import UIKit
import SnapKit
import Lottie

final class ThreeDotsIndicator: UIView {
    enum State {
        case stopped
        case animating
    }
    
    private struct Appearance {
        static let defaultDuration: TimeInterval = 2.25
        static let defaultParam1: Double = -0.06
        static let defaultParam2: Double = 0.255
        static let defaultDelay: TimeInterval = 0.2
        
        static let defaultNumberOfDots: Int = 3
        static let inset: CGFloat = 2
        
        let iterationsCount: Int = 100
        let dotSize: CGSize = .init(width: 8, height: 8)
        let viewHeight: CGFloat = -16
        let alphaRange: ClosedRange<CGFloat> = (0.3...1)
        let animationDuration: TimeInterval = 0.3
        let e: Double = 2.17
    }
    
    private var state: State = .stopped
    private let numberOfDots: Int
    private let appearance = Appearance()
        
    private lazy var dots: [UIView] = {
        (0..<numberOfDots).map { count in
            let view = UIView(frame: CGRect(origin: .zero, size: appearance.dotSize))
            view.layer.cornerRadius = appearance.dotSize.height / 2
            view.backgroundColor = .black
            view.alpha = 0
            return view
        }
    }()

    private var duration: TimeInterval {
        didSet { updateAllAnimations() }
    }
    private var param1: Double {
        didSet { updateAllAnimations() }
    }
    private var param2: Double {
        didSet { updateAllAnimations() }
    }
    private var delay: TimeInterval {
        didSet { set(state: state) }
    }
    private var animations: [UIView: CAKeyframeAnimation] = [:]
    
    override var intrinsicContentSize: CGSize {
        let dotSize = appearance.dotSize
        let width = dotSize.width * CGFloat(numberOfDots) - Appearance.inset * CGFloat(numberOfDots - 1)
        let height = max(dotSize.height, appearance.viewHeight)
        return CGSize(width: width, height: height)
    }
    
    init(
        numberOfDots: Int = Appearance.defaultNumberOfDots,
        duration: TimeInterval = Appearance.defaultDuration,
        param1: Double = Appearance.defaultParam1,
        param2: Double = Appearance.defaultParam2,
        delay: Double = Appearance.defaultDelay
    ) {
        self.numberOfDots = numberOfDots
        self.duration = duration
        self.param1 = param1
        self.param2 = param2
        self.delay = delay
        super.init(frame: .zero)
        self.updateAllAnimations()
        addSubviews()
        remakeConstraints()
    }
    
    required init?(coder: NSCoder) {
        numberOfDots = Appearance.defaultNumberOfDots
        self.duration = Appearance.defaultDuration
        self.param1 = Appearance.defaultParam1
        self.param2 = Appearance.defaultParam2
        self.delay = Appearance.defaultDelay
        super.init(coder: coder)
        self.updateAllAnimations()
        addSubviews()
        remakeConstraints()
    }
    
    public func start(
        duration: TimeInterval? = nil,
        p1: Double? = nil,
        p2: Double? = nil
    ) {
        self.duration = duration ?? self.duration
        self.param1 = p1 ?? self.param1
        self.param2 = p2 ?? self.param2
        set(state: .animating)
    }
    
    public func stop() {
        set(state: .stopped)
    }
    
    private func addSubviews() {
        dots.forEach{ addSubview(_: $0) }
    }
    
    private func remakeConstraints() {
        var left = snp.left
        var inset: CGFloat = 0
        for count in 0..<numberOfDots {
            let dot = dots[count]
            dot.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.left.equalTo(left).inset(inset)
                $0.size.equalTo(appearance.dotSize)
            }
            left = dot.snp.right
            inset = Appearance.inset
        }
        layoutIfNeeded()
    }
    
    private func set(state: State) {
        switch state {
        case .stopped:
            for dot in dots { dot.layer.removeAllAnimations() }
            
        case .animating:
            for count in 0..<dots.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(count) * delay, execute: {
                    self.animateDot(number: count)
                    if count == self.dots.count - 1 {
                        self.dots.forEach { $0.alpha = 0.3 }
                    }
                })
            }
        }
        self.state = state
    }
    
    private func animateDot(number: Int) {
        guard number < numberOfDots else {
            return
        }
        let dot = dots[number]
        guard let animation = animations[dot] else { return }
        dot.layer.add(animation, forKey: "basic")
    }
    
    private func updateAllAnimations() {
        dots.forEach { updateAnimation(forDot: $0, duration: duration, param1: param1, param2: param2) }
    }
    
    private func updateAnimation(
        forDot dot: UIView,
        duration: TimeInterval,
        param1: Double,
        param2: Double
    ) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isAdditive = true
        
        animation.values = (0..<appearance.iterationsCount).map { x in
            let dX = Double(x)
            let dY = Double(appearance.viewHeight) * pow(appearance.e, param1 * dX) * sin(param2 * dX)
            let point = CGPoint(x: dot.frame.midX, y: dot.frame.minY - appearance.viewHeight + CGFloat(dY))
            return NSValue(cgPoint: point)
        }
        animations.updateValue(animation, forKey: dot)
    }
}
