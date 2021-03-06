//
//  iOS_StageView.swift
//  VelovedGame
//
//  Created by eandrade21 on 3/17/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import UIKit
import VelovedCommon

class iOS_StageView: UIView {

    let viewTransform: StageViewTransform
    var stageViewLog: StageViewLog
    let viewFactory: iOS_StageElementViewFactory
    var delegate: InputViewDelegate?

    var tapGR: UITapGestureRecognizer!
    var rightSGR: UISwipeGestureRecognizer!
    var leftSGR: UISwipeGestureRecognizer!
    var upSGR: UISwipeGestureRecognizer!
    var downSGR: UISwipeGestureRecognizer!

    var showPlaySymbol: Bool = false

    init() {
        let ios_transform = iOS_StageViewTransform()
        viewTransform = StageViewTransform(deviceTransform: ios_transform)
        stageViewLog = StageViewLog(viewTransform: viewTransform)
        viewFactory = iOS_StageElementViewFactory()
        let frame = viewTransform.getStageFrame()

        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        delegate = nil
        stageViewLog.purgeLog()
    }
    
    func drawStage() {
        frame = viewTransform.getStageFrame()
    }
    
    func drawElement(element: StageElement) {

        if let stageElementView = stageViewLog.getStageElementView(element) {
            stageElementView.views.map() { $0.removeFromSuperview() }
        }

        let newStageElementView = viewFactory.stageElementView(forElement: element, transform: viewTransform)
        newStageElementView.views.map() { self.addSubview($0 as! UIView) }

        stageViewLog.setStageElementView(newStageElementView, forElement: element)
    }

}

extension iOS_StageView {

    func setUpGestureRecognizers() {

        setUpTapGestureRecognizers()
        setUpSwipeGestureRecognizers()
        setUpGestureRecognizersDirection()
    }

    func setUpTapGestureRecognizers() {

        tapGR = UITapGestureRecognizer(target: self, action: "pauseGame:")
        tapGR.numberOfTapsRequired = 2
        addGestureRecognizer(tapGR)
    }

    func setUpSwipeGestureRecognizers() {
        rightSGR = UISwipeGestureRecognizer(target: self, action: "steerPlayer:")
        rightSGR.numberOfTouchesRequired = 1
        addGestureRecognizer(rightSGR)

        leftSGR = UISwipeGestureRecognizer(target: self, action: "steerPlayer:")
        leftSGR.numberOfTouchesRequired = 1
        addGestureRecognizer(leftSGR)

        upSGR = UISwipeGestureRecognizer(target: self, action: "steerPlayer:")
        upSGR.numberOfTouchesRequired = 1
        addGestureRecognizer(upSGR)

        downSGR = UISwipeGestureRecognizer(target: self, action: "steerPlayer:")
        downSGR.numberOfTouchesRequired = 1
        addGestureRecognizer(downSGR)
    }

    func setUpGestureRecognizersDirection() {

        var direction = viewTransform.getDirection(Direction.Right)
        var swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        rightSGR.direction = swipeDirection

        direction = viewTransform.getDirection(Direction.Left)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        leftSGR.direction = swipeDirection

        direction = viewTransform.getDirection(Direction.Up)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        upSGR.direction = swipeDirection

        direction = viewTransform.getDirection(Direction.Down)
        swipeDirection = UISwipeGestureRecognizerDirection(UInt(direction.rawValue))
        downSGR.direction = swipeDirection

    }

    func dismantelGestureRecognizers() {
        rightSGR = nil
        leftSGR = nil
        upSGR = nil
        downSGR = nil
    }

    func steerPlayer(gestureRecognizer: UIGestureRecognizer) {

        var direction: Direction

        switch gestureRecognizer {
        case rightSGR:
            direction = Direction.Right
        case leftSGR:
            direction = Direction.Left
        case upSGR:
            direction = Direction.Up
        case downSGR:
            direction = Direction.Down
        default:
            direction = Direction.Unknown
        }

        if delegate != nil {
            delegate?.processSwipe(direction)
        }
    }

    func pauseGame(gestureRecognizer: UIGestureRecognizer) {
        if let _ = delegate {
            showPlaySymbol = delegate!.processPauseOrResumeTouch()


            dispatch_async(dispatch_get_main_queue()) {
                if self.showPlaySymbol {
                    self.showPlayView()
                } else {
                    self.showPauseView()
                }
            }
        }
    }

    func showPlayView() {
        let playButton = PlayButtonView(frame: bounds)
        addSubview(playButton)

        UIView.animateWithDuration(2,
            delay: 0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { playButton.alpha = 0 },
            completion: { (completion) in playButton.removeFromSuperview() })
    }

    func showPauseView() {
        let pauseButton = PauseButtonView(frame: bounds)
        addSubview(pauseButton)

        UIView.animateWithDuration(2,
            delay: 0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: { pauseButton.alpha = 0 },
            completion: { (completion) in pauseButton.removeFromSuperview() })
    }
}

extension iOS_StageView: UIKeyInput {

    func hasText() -> Bool {
        return false
    }

    func insertText(text: String) {
        if delegate != nil {
            delegate?.processKeyInput(text, transform: viewTransform)
        }
    }

    func deleteBackward() { }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }

}