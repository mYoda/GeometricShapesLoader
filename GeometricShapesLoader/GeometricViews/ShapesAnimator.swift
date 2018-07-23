//
//  ShapesAnimator.swift
//  GeometricShapesLoader
//
//  Created by Anton Nechayuk on 21.07.18.
//  Copyright © 2018 Anton Nechayuk. All rights reserved.
//

import UIKit

fileprivate enum FigureTypes: Int {
    case circle = 1
    case triangle
    case quarter
    case polygone
    case segment
    case rectangle
}

class GeometricShapesSceneView: UIView, CAAnimationDelegate {
    
    private let duration: CFTimeInterval = 1
    private var cgColors = [CGColor]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        run()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func run() {
        for _ in 1...4 {
            addFigureToScene()
        }
    }
    
    public func stop() {
        self.removeFromSuperview()
    }
    
    private func addFigureToScene() {
        let nRaw = Int.random(range: 1...7)
        let figureType = FigureTypes(rawValue: nRaw)!
        print(nRaw)
        switch figureType {
        case .circle:
            addCircleLayer()
        case .polygone:
            addPolygoneLayer()
        case .triangle:
            addTriangleLayer()
        case .segment:
            addSegmentLayer()
        case .rectangle:
            addRectangle()
        default:
            addQuarterLayer()
        }
    }
    
    private func createAnimatedLayerWithPath(_ bezierPath: UIBezierPath) {
        let layer = CAShapeLayer()
        layer.path = bezierPath.cgPath
        layer.fillColor = getRandomColour().cgColor
        layer.frame.origin = CGPoint(x: center.x, y: frame.height - 200)
        
        self.layer.addSublayer(layer)
        
        addAnimationRotation(to: layer)
        addAnimationMovement(to: layer)
    }
    
    //MARK: Shapes
    private func addCircleLayer() {
        let radius = Int.random(range: 15...25)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(radius), startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: true)
        createAnimatedLayerWithPath(path)
    }
    
    private func addSegmentLayer() {
        let radius = Int.random(range: 15...25)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(radius), startAngle: 0.0, endAngle: CGFloat( Int.random(range: 30...180) ).radian(), clockwise: true)
        path.addLine(to: CGPoint.zero)
        path.close()
        createAnimatedLayerWithPath(path)
    }
    
    private func addRectangle() {
        let height = Int.random(range: 15...30)
        let width = Int.random(range: 25...45)
        let points = [CGPoint.zero,
                      CGPoint(x: 0, y: height),
                      CGPoint(x: width, y: height),
                      CGPoint(x: width, y: 0)]
        
        let polygonePath = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                polygonePath.move(to: point)
                continue
            }
            polygonePath.addLine(to: point)
        }
        polygonePath.close()
        
        createAnimatedLayerWithPath(polygonePath)
    }
    
    private func addPolygoneLayer() {
        let facetsCount = Int.random(range: 5...7)
        let radius = Int.random(range: 13...20)
        let polygoneLayerPoints = generatePolygonCGPoints(facetsCount: facetsCount,  angle: 0, radius: CGFloat(radius), center: CGPoint.zero)
        let polygonePath = UIBezierPath()
        for (index, point) in polygoneLayerPoints.enumerated() {
            if index == 0 {
                polygonePath.move(to: point)
                continue
            }
            polygonePath.addLine(to: point)
        }
        polygonePath.close()
        
        createAnimatedLayerWithPath(polygonePath)
    }
    
    private func addTriangleLayer() {
        let facetsCount = 3
        let radius = Int.random(range: 13...35)
        let polygoneLayerPoints = generatePolygonCGPoints(facetsCount: facetsCount,  angle: 0, radius: CGFloat(radius), center: CGPoint.zero)
        let polygonePath = UIBezierPath()
        for (index, point) in polygoneLayerPoints.enumerated() {
            if index == 0 {
                polygonePath.move(to: point)
                continue
            }
            polygonePath.addLine(to: point)
        }
        polygonePath.close()
        createAnimatedLayerWithPath(polygonePath)
    }
    
    private func addQuarterLayer() {
        let facetsCount = 4
        let radius = Int.random(range: 17...35)
        let polygoneLayerPoints = generatePolygonCGPoints(facetsCount: facetsCount,  angle: 0, radius: CGFloat(radius), center: CGPoint.zero)
        let polygonePath = UIBezierPath()
        for (index, point) in polygoneLayerPoints.enumerated() {
            if index == 0 {
                polygonePath.move(to: point)
                continue
            }
            polygonePath.addLine(to: point)
        }
        polygonePath.close()
        createAnimatedLayerWithPath(polygonePath)
    }
    
    private func getRandomColour() -> UIColor {
        let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0.1090076491, green: 0.808973074, blue: 0.1021158919, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        var random = Int.random(range: 0...colors.count)
        while cgColors.contains(colors[random].cgColor) {
            random = Int.random(range: 0...colors.count)
        }
        self.cgColors.append(colors[random].cgColor)
        return colors[random]
    }
    
    //MARK: Animations
    private func addAnimationRotation(to layer: CAShapeLayer) {
        let leftRotation = Int.random(range: 1...10)
        let values = leftRotation % 2 == 0 ? [Double.pi*2, Double.pi*3/2, Double.pi, Double.pi/2, 0 ] : [0, Double.pi/2, Double.pi, Double.pi*3/2, Double.pi*2]
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.fillMode = kCAFillModeForwards
        rotation.values = values
        rotation.keyTimes = [0.0, 0.1, 0.8, 0.9, 1.0]
        rotation.duration = duration * 2
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func addAnimationMovement(to layer: CAShapeLayer) {
        
        let y = CGFloat( Int.random(range: 150...320) )
        let x = CGFloat( Int.random(range: -40...40) )
        
        let startPoint = layer.frame.origin
        let endPoint = CGPoint(x: layer.frame.origin.x + x, y: layer.frame.origin.y - y)
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.values = [startPoint, endPoint, startPoint]
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)]
        animation.delegate = self
        animation.setValue(layer, forKey: "layer")
        
        layer.add(animation, forKey: "position")
    }
    
    
    
    private func addAnimationMovement2(to layer: CAShapeLayer) {
        
        let y = CGFloat( Int.random(range: 150...300) )
        let x = CGFloat( Int.random(range: -30...30) )
        
        let startPoint = layer.frame.origin
        let endPoint = CGPoint(x: layer.frame.origin.x + x, y: layer.frame.origin.y - y)
        
        let allPoints : [CGPoint] = {
            let some = 20// = 21 points (first point will be duplicated)
            let distance = startPoint.y - endPoint.y
            let deltaY = distance / CGFloat(some)
            let deltaX = (startPoint.x - endPoint.x) / CGFloat(some)
            var allP = [CGPoint]()
            allP.append(startPoint)
            for _ in 1...some {
                let lastPoint = allP.last!
                let point = CGPoint(x: lastPoint.x - deltaX, y: lastPoint.y - deltaY)
                allP.append(point)
            }
            
            var result = allP.compactMap({ $0 })
            
            allP.removeLast()
            
            while let p = allP.popLast() {
                result.append(p)
            }
            
            return result
        }()
        
        let p1 = CGPoint(x: 0, y: 0)
        let cp1 = CGPoint(x: CGFloat(allPoints.count), y: 0.3)
        let cp2 = CGPoint(x: 0, y: 0.95)
        let p2 = CGPoint(x: allPoints.count, y: 1)
        
        let timeValuesPoints = getCubeCurvePoints(p0: p1, p1: cp1, p2: cp2, p3: p2, pointCount: allPoints.count)
        
        let keyTimes = timeValuesPoints.map { (point) -> NSNumber in
            return NSNumber(value: Double(point.y))
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.values = allPoints
        animation.keyTimes = keyTimes
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        animation.setValue(layer, forKey: "layer")
        
        layer.add(animation, forKey: "position")
    }
    
    
    private func addAnimationMovement3(to layer: CAShapeLayer) {
        
        let y = CGFloat( Int.random(range: 150...300) )
        let x = CGFloat( Int.random(range: -30...30) )
        
        let startPoint = layer.frame.origin
        let endPoint = CGPoint(x: layer.frame.origin.x + x, y: layer.frame.origin.y - y)
        
        let allPoints : [CGPoint] = {
            let some = 20//
            let distance = startPoint.y - endPoint.y
            let deltaY = distance / CGFloat(some)
            let deltaX = (startPoint.x - endPoint.x) / CGFloat(some)
            var allP = [CGPoint]()
            allP.append(startPoint)
            for _ in 1...some {
                let lastPoint = allP.last!
                let point = CGPoint(x: lastPoint.x - deltaX, y: lastPoint.y - deltaY)
                allP.append(point)
            }
            
            return allP
        }()
        
        let p1 = CGPoint(x: 0, y: 0)
        
        let cp1 = CGPoint(x: CGFloat(allPoints.count)*2, y: 0.05)
        
        let p2 = CGPoint(x: allPoints.count, y: 1)
        
        let timeValuesPoints = getQuadCurvePoints(p1: p1, p2: cp1, p3: p2, pointCount: allPoints.count)
        
        let keyTimes = timeValuesPoints.map { (point) -> NSNumber in
            return NSNumber(value: Double(point.y))
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = duration
        animation.values = allPoints
        animation.keyTimes = keyTimes
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.autoreverses = true
        animation.delegate = self
        animation.setValue(layer, forKey: "layer")
        
        layer.add(animation, forKey: "position")
    }
    
    //MARK: CAANimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            if let posAnimation = anim as? CAKeyframeAnimation, posAnimation.keyPath == "position" {
                if let layer = anim.value(forKey: "layer") as? CAShapeLayer {
                    layer.removeFromSuperlayer()
                    addFigureToScene()
                    if let colorIndex = cgColors.index(of: layer.fillColor!) {
                        cgColors.remove(at: colorIndex)
                    }
                }
            }
        }
    }
    
    //MARK: Helpers
    
    //Bezier curves point generators
    private func getQuadCurvePoints(p1: CGPoint, p2: CGPoint, p3: CGPoint, pointCount: Int) -> [CGPoint] {
        //t⋲[0,1]
        //2 points: P = (1-t)P1 + tP2
        //3 points: P = (1−t)2P1 + 2(1−t)tP2 + t2P3
        //4 points: P = (1−t)3P1 + 3(1−t)2tP2 +3(1−t)t2P3 + t3P4
        let offset: Double = 1 / (Double(pointCount) - 1)
        var points: [CGPoint] = []
        for t in stride(from: 0.0, to: 1.0, by: offset) {
            
            let x0 = pow((1-t), 2) * Double(p1.x)
            let x1 = 2 * (1-t) * t * Double(p2.x)
            let x2 = pow(t, 2) * Double(p3.x)
            let X = x0 + x1 + x2
            
            let y0 = pow((1-t), 2) * Double(p1.y)
            let y1 = 2 * (1-t) * t * Double(p2.y)
            let y2 = pow(t, 2) * Double(p3.y)
            let Y = y0 + y1 + y2
            points.append(CGPoint(x: X, y: Y))
        }
        
        points.append(p3)
        
        return points
    }
    
    private func getCubeCurvePoints(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint, pointCount: Int) -> [CGPoint] {
        //t ⋲ [0,1]
        //2 points: P = (1-t)P1 + tP2
        //3 points: P = (1−t)2P1 + 2(1−t)tP2 + t2P3
        //4 points: P = (1−t)3P1 + 3(1−t)2tP2 +3(1−t)t2P3 + t3P4
        
        let offset: Double = 1 / (Double(pointCount) - 1)
        var points: [CGPoint] = []
        for t in stride(from: 0.0, to: 1.0, by: offset) {
            let x0 = pow((1-t), 3) * Double(p0.x)
            let x1 = 3 * t * pow((1-t), 2) * Double(p1.x)
            let x2 = 3 * pow(t, 2) * (1-t) * Double(p2.x)
            let x3 = pow(t, 3) * Double(p3.x)
            let X = x0 + x1 + x2 + x3
            
            let y0 = pow((1-t), 3) * Double(p0.y)
            let y1 = 3 * t * pow((1-t), 2) * Double(p1.y)
            let y2 = 3 * pow(t, 2) * (1-t) * Double(p2.y)
            let y3 = pow(t, 3) * Double(p3.y)
            let Y = y0 + y1 + y2 + y3
            points.append(CGPoint(x: X, y: Y))
        }
        points.append(p3)
        
        return points
    }
    
    private func generatePolygonCGPoints(facetsCount: Int, angle: CGFloat = 0, radius: CGFloat, center: CGPoint) -> [CGPoint] {
        var points = [CGPoint]()
        let center = center
        for n in 0...(facetsCount - 1) {
            let nFloat = CGFloat(n)
            let angleRad = angle * CGFloat.pi / 180
            let expression = angleRad + CGFloat(2.0) * CGFloat.pi * nFloat / CGFloat(facetsCount)
            
            let x = center.x - radius * cos( expression)
            let y = center.y - radius * sin( expression)
            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        return points
    }
}

fileprivate extension Int
{
    static func random(range: CountableClosedRange<Int> ) -> Int
    {
        var offset = 0
        
        if range.lowerBound < 0   // allow negative ranges
        {
            offset = abs(range.lowerBound)
        }
        
        let mini = UInt32(range.lowerBound + offset)
        let maxi = UInt32(range.upperBound   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

fileprivate extension CGFloat {
    func radian() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}
