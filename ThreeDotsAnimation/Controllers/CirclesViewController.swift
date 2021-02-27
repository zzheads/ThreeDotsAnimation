//
//  CirclesViewController.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 27.02.2021.
//

import SnapKit



final class CirclesViewController: UIViewController {
    let first = Circle(
        side: SquareSide(axis: .x, multiplier: 0.15),
        center: Point(
            x: Coordinate(edge: .left, multiplier: 0.4),
            y: Coordinate(edge: .top, multiplier: 0.4)
        ),
        backgroundColor: .red
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        first.addAndSetup(onView: view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let function: (Double) -> Double = { x in
            return -pow(2.71 * 0.396, x * 0.3)
        }
        first.animate(duration: 2, function: function)
    }
}
