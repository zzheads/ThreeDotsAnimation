//
//  Circle.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 27.02.2021.
//

import SnapKit

struct Circle {
    private struct Appearance {
        let iterationsCount: Int = 300
        let keyPathPositionName = "position"
        let animationLayerName = "basic"
    }

    private let appearance = Appearance()
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
        duration: TimeInterval,
        function: @escaping ((Double) -> Double),
        repeatCount: Float = 1,
        timingFunctionName: CAMediaTimingFunctionName = .default
    ) {
        let animation = makeAnimation(duration: duration,
                                      function: function,
                                      repeatCount: repeatCount,
                                      timingFunctionName: timingFunctionName)
        view.layer.add(animation, forKey: appearance.animationLayerName)
    }

    private func makeAnimation(
        duration: TimeInterval,
        function: @escaping ((Double) -> Double),
        repeatCount: Float,
        timingFunctionName: CAMediaTimingFunctionName
    ) -> CAKeyframeAnimation
    {
        let animation = CAKeyframeAnimation()
        animation.keyPath = appearance.keyPathPositionName
        animation.timingFunction = .init(name: timingFunctionName)
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isAdditive = true

        animation.values = (0..<appearance.iterationsCount).map { x in
            let dX = Double(x)
            let dY = function(dX)
            let point = CGPoint(x: view.frame.midX + CGFloat(dX), y: view.frame.midY + CGFloat(dY))
            return NSValue(cgPoint: point)
        }
        return animation
    }

}
