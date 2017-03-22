//: Playground - noun: a place where people can play

import PlaygroundSupport
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
        let endAngle: CGFloat = CGFloat(M_PI * 2)
        
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
        progressLayer.strokeEnd = CGFloat(M_PI_4 / 80)
        
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
        case ProgressLayerStart
        case ProgressLayerOngoing
        case ProgressLayerEnd
        
        case ResultColor
        case ResultStrokeColor
        case ResultFillColor
        case ResultMark
    }
    
    private enum Duration: CFTimeInterval {
        case duration = 0.8
        case start = 0.533333333 //.ongoing / 0.75
        case ongoing = 1.6 // .duration / 0.5
        case end = 9.6 // .ongoing * 12
        case actualEnd = 1.3
        
        // The multiplier doesn't make sense, but it works
        // But I wanted to make a point 🦄
        // It should be something like 1.3 (actualEnd)
        
        case resultColor = 0.6
        case resultMark = 0.3
    }
    
    func startAnimation() {
        resetLayers()
        
        performAnimation(animation: .ProgressLayerStart)
        performAnimation(animation: .ProgressLayerOngoing)
    }
    
    func endAnimation(withResult result: Result, _ completion: (() -> Swift.Void)? = nil) {
        self.result = result
        // Lot's of indendation here..
        performAnimation(animation: .ProgressLayerEnd) {
            Thread.sleep(forTimeInterval: Duration.actualEnd.rawValue)
            self.performAnimation(animation: .ResultColor, {
                self.performAnimation(animation: .ResultMark, {
                    if let completion = completion {
                        completion()
                    }
                })
            })
        }
    }
    
    // MARK: Animation (Private)
    
    private func performAnimation(animation: Animation, _ completion: (() -> Swift.Void)? = nil) {
        CATransaction.begin()
        
        switch animation {
        case .ProgressLayerStart:
            performStartAnimation()
            break
        case .ProgressLayerOngoing:
            performOngoingAnimation()
            break
        case .ProgressLayerEnd:
            performEndAnimation()
            break
            
        case .ResultColor where result != nil:
            performResultColorAnimation(result: result!)
            break
        case .ResultMark where result != nil:
            performResultMarkAnimation(result: result!)
            break
            
        default:
            break
        }
        
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()
    }
    
    private func performStartAnimation() {
        let startAngle = CGFloat(M_PI_2 / 40)
        let endAngle = CGFloat(M_PI_2 / 10)
        
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = Duration.start.rawValue
        animation.fromValue = startAngle
        animation.toValue = endAngle
        
        progressLayer.strokeEnd = endAngle
        
        progressLayer.add(animation, forKey: .ProgressLayerStart)
    }
    
    private func performOngoingAnimation() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = Duration.ongoing.rawValue
        animation.fromValue = 0.0
        animation.toValue = 2.0 * M_PI
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        
        progressLayer.add(animation, forKey: .ProgressLayerOngoing)
    }
    
    private func performEndAnimation() {
        let startAngle = progressLayer.strokeEnd
        let endAngle = CGFloat(M_PI * 2)
        
        let animation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = Duration.end.rawValue
        animation.fromValue = startAngle
        animation.toValue = endAngle
        
        progressLayer.strokeEnd = endAngle
        progressLayer.add(animation, forKey: .ProgressLayerEnd)
    }
    
    // Results
    
    var result: Result?
    
    enum Result {
        case success
    }
    
    // All credit for the checkmark and it's animation goes out to @Tueno's MaterialCircularProgress
    // See https://github.com/Tueno/MaterialCircularProgress/blob/master/LICENSE
    
    private var CheckmarkPath: UIBezierPath {
        get {
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
    }
    
    private let resultLayer = CAShapeLayer()
    
    private func color(forResult result: Result) -> UIColor {
        var color = UIColor.clear
        switch result {
        case .success:
            color = UIColor(red:0.30, green:0.84, blue:0.13, alpha:1.00)
        }
        
        return color
    }
    
    private func performResultColorAnimation(result: Result) {
        let cgColor = color(forResult: result).cgColor
        
        let fillAnimation = CABasicAnimation()
        fillAnimation.keyPath = "fillColor"
        fillAnimation.fromValue = progressLayer.fillColor
        fillAnimation.toValue = cgColor
        fillAnimation.duration = Duration.resultColor.rawValue
        
        let strokeAnimation = CABasicAnimation()
        strokeAnimation.keyPath = "strokeColor"
        strokeAnimation.fromValue = progressLayer.strokeColor
        strokeAnimation.toValue = cgColor
        strokeAnimation.duration = Duration.resultColor.rawValue
        
        progressLayer.fillColor = cgColor
        progressLayer.strokeColor = cgColor
        progressLayer.add(fillAnimation, forKey: .ResultFillColor)
        progressLayer.add(strokeAnimation, forKey: .ResultStrokeColor)
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
    
    private func performResultMarkAnimation(result: Result) {
        resetResultLayer(forResult: result)
        
        let markAnimation = CABasicAnimation()
        markAnimation.keyPath = "strokeEnd"
        markAnimation.toValue = 1.0
        markAnimation.fillMode = kCAFillModeForwards
        markAnimation.isRemovedOnCompletion = false
        markAnimation.duration = Duration.resultMark.rawValue
        resultLayer.add(markAnimation, forKey: .ResultMark)
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


let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)

let spinner = DownSpinner()
spinner.center = view.center
view.addSubview(spinner)

spinner.color = UIColor.blue
spinner.resultColor = UIColor.orange

PlaygroundPage.current.liveView = view
NSLog("Reloaded on %@", NSDate())

DispatchQueue.global().asyncAfter(deadline: .now()) {
    while(true) {
        NSLog("Starting on %@", NSDate())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            spinner.startAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            spinner.endAnimation(withResult: .success, {
                NSLog("Animation done")
            })
        }
        
        sleep(8)
    }
}
