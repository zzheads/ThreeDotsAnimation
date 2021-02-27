//
//  Circle.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 27.02.2021.
//

import SnapKit

struct Circle {
    private enum Appearance {
        static let iterationsCount: Int = 300
    }

    private let side: SquareSide
    private let center: Point

    private var size: CGSize {
        let length = side.length(view)
        return CGSize(width: length, height: length)
    }

    var backgroundColor: UIColor? {
        didSet { view.backgroundColor = backgroundColor }
    }

    private var view: UIView

    init(side: SquareSide, center: Point, backgroundColor: UIColor? = nil) {
        self.side = side
        self.center = center
        self.backgroundColor = backgroundColor
        view = UIView()
        view.backgroundColor = backgroundColor
    }

    func addAndSetup(onView superview: UIView) {
        superview.addSubview(view)
        makeConstraints()
        view.layer.cornerRadius = side.length(view) / 2
    }

    func makeConstraints() {
        center.makeConstraints(view)
        side.makeConstraints(view)
    }

    func animate(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions,
        transform: CGAffineTransform,
        completion: ((Bool) -> Void)? = nil
    ) {
        let animations: () -> Void = { [weak view] in view?.transform = transform }
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
    }

    func animate(
        duration: TimeInterval = 0.3,
        function: @escaping ((Double) -> Double),
        completion: ((Bool) -> Void)? = nil
    ) {
        view.layer.add(animation(duration: duration, function: function), forKey: "basic")
    }

    private func animation(duration: TimeInterval, function: @escaping ((Double) -> Double)) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.isAdditive = true

        animation.values = (0..<Appearance.iterationsCount).map { x in
            let dX = Double(x)
            let dY = function(dX)
            let point = CGPoint(x: view.frame.midX - CGFloat(dX), y: view.frame.minY + CGFloat(dY))
            return NSValue(cgPoint: point)
        }
        return animation
    }

}
