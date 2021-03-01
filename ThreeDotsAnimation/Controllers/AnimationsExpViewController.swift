//
//  AnimationsExpViewController.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 27.02.2021.
//

import SnapKit

final class AnimationsExpViewController: UIViewController {
    struct Appearance {
        let layerSize = CGSize(width: 100, height: 100)
        let initialPosition = CGPoint(x: 50, y: 50)
        let targetPosition = CGPoint(x: 350, y: 550)
    }

    private let appearance = Appearance()

    lazy var layer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.green.cgColor
        layer.frame = CGRect(origin: appearance.initialPosition, size: appearance.layerSize)
        layer.cornerRadius = appearance.layerSize.height / 2
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.layer.addSublayer(layer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        CATransaction.setAnimationDuration(3)

        layer.position = appearance.targetPosition
        layer.backgroundColor = UIColor.yellow.cgColor
        layer.frame.size = CGSize(width: appearance.layerSize.width / 2, height: appearance.layerSize.height / 2)
        layer.cornerRadius = appearance.layerSize.height / 4

        CATransaction.commit()
    }
}
