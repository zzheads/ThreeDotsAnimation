//
//  ViewController.swift
//  ThreeDotsAnimation
//
//  Created by Алексей Папин on 14.02.2021.
//

import UIKit
import SnapKit

class ThreeDotsViewController: UIViewController {
    private struct Appearance {
        static let initialValue = (duration: TimeInterval(1), p1: Double(-0.035), p2: Double(0.06))
    }
    
    let indicator = ThreeDotsIndicator(numberOfDots: 3)
    
    private var duration: TimeInterval = Appearance.initialValue.duration {
        didSet {
            durationLabel.text = "Duration: \(duration)"
            indicator.stop()
            indicator.start(duration: duration, p1: p1, p2: p2)
        }
    }
    private var p1: Double = Appearance.initialValue.p1 {
        didSet {
            p1Label.text = "P1: \(p1)"
            indicator.stop()
            indicator.start(duration: duration, p1: p1, p2: p2)
        }
    }
    private var p2: Double = Appearance.initialValue.p2 {
        didSet {
            p2Label.text = "P2: \(p2)"
            indicator.stop()
            indicator.start(duration: duration, p1: p1, p2: p2)
        }
    }

    let durationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = Float(Appearance.initialValue.duration)
        slider.addTarget(self, action: #selector(valueDidChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    let p1Slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -0.1
        slider.maximumValue = 0.1
        slider.value = Float(Appearance.initialValue.p1)
        slider.addTarget(self, action: #selector(valueDidChanged(_:)), for: .valueChanged)
        return slider
    }()

    let p2Slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(Appearance.initialValue.p2)
        slider.addTarget(self, action: #selector(valueDidChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let p1Label: UILabel = {
        let label = UILabel()
        return label
    }()

    let p2Label: UILabel = {
        let label = UILabel()
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(indicator)
        view.addSubview(durationSlider)
        view.addSubview(p1Slider)
        view.addSubview(p2Slider)
        view.addSubview(durationLabel)
        view.addSubview(p1Label)
        view.addSubview(p2Label)
        
        indicator.snp.makeConstraints { $0.center.equalToSuperview() }
        durationSlider.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.left.right.equalToSuperview().inset(32)
        }
        durationLabel.snp.makeConstraints {
            $0.bottom.equalTo(durationSlider.snp.top).offset(-8)
            $0.left.right.equalToSuperview().inset(32)
        }
        
        p2Slider.snp.makeConstraints {
            $0.bottom.equalTo(durationLabel.snp.top).offset(-16)
            $0.left.right.equalToSuperview().inset(32)
        }
        p2Label.snp.makeConstraints {
            $0.bottom.equalTo(p2Slider.snp.top).offset(-8)
            $0.left.right.equalToSuperview().inset(32)
        }

        p1Slider.snp.makeConstraints {
            $0.bottom.equalTo(p2Label.snp.top).offset(-16)
            $0.left.right.equalToSuperview().inset(32)
        }
        p1Label.snp.makeConstraints {
            $0.bottom.equalTo(p1Slider.snp.top).offset(-8)
            $0.left.right.equalToSuperview().inset(32)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        duration = Appearance.initialValue.duration
        p1 = Appearance.initialValue.p1
        p2 = Appearance.initialValue.p2
    }

    @objc private func valueDidChanged(_ sender: UISlider) {
        switch sender {
        case durationSlider:
            duration = TimeInterval(sender.value)
            
        case p1Slider:
            p1 = Double(sender.value)

        case p2Slider:
            p2 = Double(sender.value)
            
        default:
            break
        }
    }
}

