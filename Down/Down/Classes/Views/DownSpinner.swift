//
//  DownSpinner.swift
//  Down
//
//  Created by Ruud Puts on 21/03/17.
//  Copyright © 2017 Ruud Puts. All rights reserved.
//

import UIKit
import QuartzCore

class DownSpinner: UIView {
    
    // MARK: Properties
    
    private var progressLayer = CAShapeLayer()
    
    init() {
        let size: CGFloat = 150.0
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupProgressLayer()
    }
    
    // MARK: Layers
    
    var color = UIColor.white
    var resultColor = UIColor.white
    
    private func setupProgressLayer() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(center.x, center.y) - progressLayer.lineWidth / 2
        let startAngle: CGFloat = CGFloat()
        let endAngle: CGFloat = CGFloat(Double.pi * 2)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = path.cgPath
        resetProgressLayer()
        
        if progressLayer.superlayer != layer {
            layer.addSublayer(progressLayer)
        }
    }
    
    private func resetLayers() {
        resetProgressLayer()
        resetResultLayer()
    }
    
    private func resetProgressLayer() {
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = color.cgColor
        progressLayer.lineWidth = bounds.width / 40
        progressLayer.frame = bounds
        
        progressLayer.strokeStart = CGFloat()
        progressLayer.strokeEnd = CGFloat(Double.pi_4 / 80)
        
        progressLayer.removeAllAnimations()
    }
    
    private func resetResultLayer() {
        resultLayer.fillColor = UIColor.clear.cgColor
        resultLayer.strokeColor = resultColor.cgColor
        resultLayer.lineWidth = bounds.width / 35
        resultLayer.strokeEnd = 0
        resultLayer.frame = bounds
        
        resultLayer.removeAllAnimations()
        resultLayer.removeFromSuperlayer()
    }
    
    // MARK: Animation
    
    fileprivate enum Animation: String {
        case progressLayerStart
        case progressLayerOngoing
        case progressLayerEnd
        
        case progressEndFillColor
        case progressEndStrokeColor
    }
    
    var duration = 0.8
    
    func startAnimation() {
        resetLayers()
        
        performStartAnimation()
        perfromOngoingAnimation()
    }
    
    private func performStartAnimation() {
        let startAngle = CGFloat(Double.pi_2 / 40)
        let endAngle = CGFloat(Double.pi_2 / 10)
        let duration = self.duration / 1.5
        
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = duration
        animation.fromValue = startAngle
        animation.toValue = endAngle
        
        progressLayer.strokeEnd = endAngle
        
        progressLayer.add(animation, forKey: .progressLayerStart)
    }
    
    func endAnimation(withResult result: Result) {
        // The multiplier doesn't make sense, but it works (And yes duration should be in performEndAnimation)
        // But I wanted to make a point 🦄
        let duration = self.duration * 12
        // It should be something like this
        let actualDuration = 1.2
        
        performEndAnimation(duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + actualDuration) {
            self.perfromResultAnimation(result: result)
        }
    }
    
    private func performEndAnimation(_ duration: Double) {
        let startAngle = progressLayer.strokeEnd
        let endAngle = CGFloat(Double.pi * 2)
        
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = duration
        animation.fromValue = startAngle
        animation.toValue = endAngle
        
        progressLayer.strokeEnd = endAngle
        progressLayer.add(animation, forKey: .progressLayerEnd)
    }
    
    // MARK: Animation (Private)
    
    private func perfromOngoingAnimation() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = self.duration / 0.5
        animation.fromValue = 0.0
        animation.toValue = 2.0 * Double.pi
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        
        progressLayer.add(animation, forKey: .progressLayerOngoing)
    }
    
    // Results
    
    enum Result {
        case success
    }
    
    // All credit for the checkmark and it's animation goes out to @Tueno's MaterialCircularProgress
    // See https://github.com/Tueno/MaterialCircularProgress/blob/master/LICENSE

    // swiftlint:disable identifier_name
    private var CheckmarkPath: UIBezierPath {
        let scaleFactor = CGFloat(5.0)
        let size  = CGSize(width: bounds.width / scaleFactor, height: bounds.height / scaleFactor)
        let path = UIBezierPath()

        let startPoint = CGPoint(x: bounds.midX - size.width / 2,
                                 y: bounds.midY)
        path.move(to: startPoint)

        let firstLineEndPoint = CGPoint(x: startPoint.x + size.width * 0.36,
                                        y: startPoint.y + size.height * 0.36)
        path.addLine(to: firstLineEndPoint)

        let secondLineEndPoint = CGPoint(x: firstLineEndPoint.x + size.width * 0.64,
                                         y: firstLineEndPoint.y - size.height)
        path.addLine(to: secondLineEndPoint)

        return path
    }
    
    private let resultLayer = CAShapeLayer()
    
    private func perfromResultAnimation(result: Result) {
        var color = UIColor.clear
        switch result {
        case .success:
            color = UIColor(red: 0.30, green: 0.84, blue: 0.13, alpha: 1.00)
        }
        let cgColor = color.cgColor
        
        let progressDuration = 0.6
        
        let fillAnimation = CABasicAnimation()
        fillAnimation.keyPath = "fillColor"
        fillAnimation.fromValue = progressLayer.fillColor
        fillAnimation.toValue = cgColor
        fillAnimation.duration = progressDuration
        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let strokeAnimation = CABasicAnimation()
        strokeAnimation.keyPath = "strokeColor"
        strokeAnimation.fromValue = progressLayer.strokeColor
        strokeAnimation.toValue = cgColor
        strokeAnimation.duration = progressDuration
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        progressLayer.fillColor = cgColor
        progressLayer.strokeColor = cgColor
        progressLayer.add(fillAnimation, forKey: .progressEndFillColor)
        progressLayer.add(strokeAnimation, forKey: .progressEndStrokeColor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + progressDuration * 0.75) {
            self.performResultMarkAnimation(forResult: result)
        }
    }
    
    private func resetResultLayer(forResult result: Result) {
        resetResultLayer()
        
        var path: UIBezierPath
        switch result {
        case .success:
            path = CheckmarkPath
        }
        resultLayer.path = path.cgPath
        
        if resultLayer.superlayer != layer {
            layer.addSublayer(resultLayer)
        }
    }
    
    private func performResultMarkAnimation(forResult result: Result) {
        resetResultLayer(forResult: result)
        
        let markAnimation = CABasicAnimation(keyPath: "strokeEnd")
        markAnimation.toValue = 1.0
        markAnimation.fillMode = kCAFillModeForwards
        markAnimation.isRemovedOnCompletion = false
        markAnimation.duration = 0.3
        resultLayer.add(markAnimation, forKey: "strokeEnd")
    }
    
}

extension CALayer {
    
    fileprivate func add(_ animation: CAAnimation, forKey key: DownSpinner.Animation) {
        add(animation, forKey: key.rawValue)
    }
    
    fileprivate func animation(forKey key: DownSpinner.Animation) -> CAAnimation? {
        return animation(forKey: key.rawValue)
    }
    
    fileprivate func removeAnimation(forKey key: DownSpinner.Animation) {
        removeAnimation(forKey: key.rawValue)
    }
    
}
