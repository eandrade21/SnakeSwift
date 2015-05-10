//
//  StageViewTransform.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

import Foundation

public enum StageOrientation {
    case Portrait
    case LandscapeRight
    case LandscapeLeft
    case PortraitUpsideDown
    case Unknow
}

public protocol DeviceStageViewTransform {
    
    func getStageFrame() -> CGRect
    func getFrame(location: StageLocation) -> CGRect
    func getDirection(direction: Direction) -> Direction
    
}

public struct StageViewTransform {
    
    var deviceTransform: DeviceStageViewTransform
    
    public init(deviceTransform: DeviceStageViewTransform) {
        self.deviceTransform = deviceTransform
    }

    public func getStageFrame() -> CGRect {
        return deviceTransform.getStageFrame()
    }
    
    public func getFrame(location: StageLocation) -> CGRect {
        return deviceTransform.getFrame(location)
    }
    
    
    public func getDirection(direction: Direction) -> Direction {
        return deviceTransform.getDirection(direction)
    }
}