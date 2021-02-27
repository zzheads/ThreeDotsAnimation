//
//  RelativeCoordinate.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 27.02.2021.
//

import UIKit
import SnapKit

enum Axis {
    case x
    case y
}

enum Edge {
    case left
    case right
    case top
    case bottom
}

protocol RelativeCoordinate {
    var edge: Edge { get }
    var multiplier: CGFloat { get }
}

struct Coordinate: RelativeCoordinate {
    let edge: Edge
    let multiplier: CGFloat

    func makeConstraints(_ view: UIView) {
        guard let superview = view.superview else { return }
        view.snp.makeConstraints { make in
            switch edge {
            case .left:
                make.left.equalTo(superview.snp.left).offset(superview.bounds.width * multiplier)
            case .right:
                make.right.equalToSuperview().inset(superview.bounds.width * multiplier)
            case .top:
                make.top.equalTo(superview.snp.top).offset(superview.bounds.height * multiplier)
            case .bottom:
                make.bottom.equalToSuperview().inset(superview.bounds.height * multiplier)
            }
        }
    }
}

struct Point {
    let x: Coordinate
    let y: Coordinate

    func makeConstraints(_ view: UIView) {
        x.makeConstraints(view)
        y.makeConstraints(view)
    }
}

// MARK: - RelativeSizeSide
protocol RelativeSizeSide {
    var axis: Axis { get }
    var multiplier: CGFloat { get }
}

extension RelativeSizeSide {
    func length(_ view: UIView?) -> CGFloat {
        guard let superview = view?.superview else { return 0 }
        switch axis {
        case .x: return superview.bounds.width * multiplier
        case .y: return superview.bounds.height * multiplier
        }
    }

    func makeConstraints(_ view: UIView) {
        view.snp.makeConstraints { make in
            switch axis {
            case .x: make.width.equalTo(length(view))
            case .y: make.height.equalTo(length(view))
            }
        }
    }
}

struct Side: RelativeSizeSide {
    let axis: Axis
    let multiplier: CGFloat
}

struct SquareSide: RelativeSizeSide {
    let axis: Axis
    let multiplier: CGFloat

    func size(_ view: UIView) -> CGSize {
        let sideLength = length(view)
        return .init(width: sideLength, height: sideLength)
    }

    func makeConstraints(_ view: UIView) {
        view.snp.makeConstraints {
            $0.size.equalTo(size(view))
        }
    }
}

