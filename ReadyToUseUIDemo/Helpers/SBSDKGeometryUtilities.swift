//
//  SBSDKGeometryUtilities.swift
//  ScanbotSDK
//
//  Created by Sebastian Husche on 25.09.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import CoreGraphics.CGGeometry

extension CGFloat {
    
    func degrees2Radians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
    
    func radians2Degrees() -> CGFloat {
        return self * 180.0 / CGFloat.pi
    }
}

extension CGPoint {
    
    func vectorWith(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - x, y: point.y - y)
    }
    
    func addedVector(_ vector: CGPoint) -> CGPoint {
        return CGPoint(x: x + vector.x, y: y + vector.y)
    }

    func subtractedVector(_ vector: CGPoint) -> CGPoint {
        return CGPoint(x: x - vector.x, y: y - vector.y)
    }
    
    var vectorLength: CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return vectorWith(point).vectorLength
    }
    
    var normalized: CGPoint {
        let length = vectorLength
        if length == 0 {
            return CGPoint(x: CGFloat.nan, y: CGFloat.nan)
        }
        return CGPoint(x: x / length, y: y / length)
    }
    
    func scaledBy(_ scalar: CGFloat) -> CGPoint {
        return CGPoint(x: x * scalar, y: y * scalar)
    }
    
    func dotProductWith(_ point: CGPoint) -> CGFloat {
        return (x * point.x) + (y * point.y)
    }
    
    func angleWithVector(_ point: CGPoint) -> CGFloat {
        return acos(self.normalized.dotProductWith(point.normalized))
    }
}

extension Array where Element == CGPoint {
    var boundingBox: CGRect {
        var minX = CGFloat.infinity
        var minY = CGFloat.infinity
        var maxX = -CGFloat.infinity
        var maxY = -CGFloat.infinity
        
        for p in self {
            minX = Swift.min(minX, p.x)
            minY = Swift.min(minY, p.y)
            maxX = Swift.max(maxX, p.x)
            maxY = Swift.max(maxY, p.y)
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

extension CGSize {
    
    var swapped: CGSize {
        return CGSize(width: self.height, height: self.width)
    }
    
    func fittedIntoSize(_ intoSize: CGSize) -> CGSize {
        let xRatio = width / intoSize.width
        let yRatio = height / intoSize.height
        let aspectRatio = width / height
        var result: CGSize = .zero
        if xRatio >= yRatio {
            result.width = intoSize.width
            result.height = result.width / aspectRatio
        } else {
            result.height = intoSize.height
            result.width = result.height * aspectRatio
        }
        return result
    }

    func filledIntoSize(_ intoSize: CGSize) -> CGSize {
        let xRatio = width / intoSize.width
        let yRatio = height / intoSize.height
        let aspectRatio = width / height
        var result: CGSize = .zero
        if xRatio <= yRatio {
            result.width = intoSize.width
            result.height = result.width / aspectRatio
        } else {
            result.height = intoSize.height
            result.width = result.height * aspectRatio
        }
        return result
    }
    
}

extension CGRect {
    
    init(size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    init(size: CGSize, center: CGPoint) {
        self.init(x: center.x - (size.width * 0.5), 
                  y: center.y - (size.height * 0.5), 
                  width: size.width, 
                  height: size.height)
    }
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    var topLeft: CGPoint {
        return CGPoint(x: minX, y: minY)
    }

    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }
    
    func clampedToSize(_ size: CGSize) -> CGRect {
        var rect = self
        rect.origin.x = max(0, origin.x)
        rect.origin.y = max(0, origin.y)
        let dx = max(0, rect.maxX) - size.width
        let dy = max(0, rect.maxY) - size.height
        rect.size.width -= dx
        rect.size.height -= dy
        return rect
    }
    
    func centeredTo(_ center: CGPoint) -> CGRect {
        var rect = CGRect(size: self.size)
        rect.origin.x = center.x - (rect.size.width * 0.5)
        rect.origin.y = center.y - (rect.size.height * 0.5)
        return rect
    }
    
    func centeredToRect(_ rect: CGRect) -> CGRect {
        return self.centeredTo(rect.center)
    }
    
    func fittedInto(_ rect: CGRect) -> CGRect {
        let fitSize = self.size.fittedIntoSize(rect.size)
        return CGRect(size: fitSize, center: rect.center)
    }
    
    func filledInto(_ rect: CGRect) -> CGRect {
        let fillSize = self.size.filledIntoSize(rect.size)
        return CGRect(size: fillSize, center: rect.center)
    }
    
    func scaledBy(_ scale: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scale, 
                      y: origin.y * scale, 
                      width: width * scale, 
                      height: height * scale)
    }
}

func scaleFactorToLimitSizeInSize(_ size: CGSize, inSize: CGSize) -> CGFloat {
    if inSize.width <= 0 || inSize.height <= 0 {
        return 1.0
    }

    if size.width <= inSize.width && size.height <= inSize.height {
        return 1.0
    }
    
    let s = size.fittedIntoSize(inSize)
    return max(s.width / size.width, s.height / size.height)
}

func scaleFactorToFitSizeInSize(_ size: CGSize, inSize: CGSize) -> CGFloat {
    let s = size.fittedIntoSize(inSize)
    return s.width / size.width;
} 

func scaleFactorToFillSizeInSize(_ size: CGSize, inSize: CGSize) -> CGFloat {
    let s = size.filledIntoSize(inSize)
    return s.width / size.width;
}

func scaleFactorToFitRectInRect(_ rect: CGRect, inRect: CGRect) -> CGFloat {
    let r = rect.fittedInto(inRect)
    return r.width / rect.width;
} 

func scaleFactorToFillRectInRect(_ rect: CGRect, inRect: CGRect) -> CGFloat {
    let r = rect.filledInto(inRect)
    return r.width / rect.width;
} 

func lerp(start: CGPoint, end: CGPoint, factor: CGFloat) -> CGPoint {
    let deltaX = end.x - start.x
    let deltaY = end.y - start.y
    return CGPoint(x: start.x + (deltaX * factor), y: start.y + (deltaY * factor))
}

struct LineIntersection {
    var intersection: CGPoint
    var segmentA: CGFloat
    var segmentB: CGFloat
}

func lineIntersection(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> LineIntersection? {
    let epsilon: Double = 0.00001
    let x1 = p1.x, x2 = p2.x, x3 = p3.x, x4 = p4.x
    let y1 = p1.y, y2 = p2.y, y3 = p3.y, y4 = p4.y
    
    let denom  = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1)
    let numera = (x4-x3) * (y1-y3) - (y4-y3) * (x1-x3)
    let numerb = (x2-x1) * (y1-y3) - (y2-y1) * (x1-x3)
    
    var intersectionPoint: CGPoint = .zero

    // Lines coincident?
    if (abs(numera) < epsilon && abs(numerb) < epsilon && abs(denom) < epsilon) {
        intersectionPoint.x = (x1 + x2) / 2.0
        intersectionPoint.y = (y1 + y2) / 2.0
        return LineIntersection(intersection: intersectionPoint, segmentA: 0.5, segmentB: 0.5)
    }
    
    if abs(denom) < epsilon {
        return nil
    }
    
    let mua = numera / denom
    let mub = numerb / denom
    
    intersectionPoint.x = x1 + mua * (x2 - x1)
    intersectionPoint.y = y1 + mua * (y2 - y1)
    
    return LineIntersection(intersection: intersectionPoint, segmentA: mua, segmentB: mub)
}

func distancePointToLine(point: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
    let lineLength = p1.vectorWith(p2).vectorLength
    
    let dx = p2.x - p1.x
    let dy = p2.y - p1.y
    
    let u = (((point.x - p1.x) * dx) + ((point.y - p1.y) * dy)) / (lineLength * lineLength)
    
    var intersection: CGPoint = .zero
    
    intersection.x = p1.x + u * dx
    intersection.y = p1.y + u * dy
    
    return point.vectorWith(intersection).vectorLength
}

func distanceLineToLine(p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> CGFloat {
    guard let intersection = lineIntersection(p1: p1, p2: p2, p3: p3, p4: p4) else {
        return min(distancePointToLine(point: p3, p1: p1, p2: p2), distancePointToLine(point: p4, p1: p1, p2: p2))
    }
    
    let u12 = intersection.segmentA
    let u34 = intersection.segmentB
    let inSegmentP1P2 = u12 >= 0.0 && u12 <= 1.0
    let inSegmentP3P4 = u34 >= 0.0 && u34 <= 1.0
    
    if inSegmentP1P2 && inSegmentP3P4 {
        return 0.0
    } 
    let minDP12P34 = min(distancePointToLine(point: p1, p1:p3, p2:p4), distancePointToLine(point: p2, p1:p3, p2:p4))
    let minDP34P12 = min(distancePointToLine(point:p3, p1:p1, p2:p2), distancePointToLine(point:p4, p1:p1, p2:p2))
    
    if inSegmentP1P2 {
        return minDP34P12
    } else if inSegmentP3P4 {
        return minDP12P34
    } else {
        return min(minDP12P34, minDP34P12)
    }
}
