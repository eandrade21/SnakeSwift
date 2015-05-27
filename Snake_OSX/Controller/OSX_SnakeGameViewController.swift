
//
//  OSX_SankeGameViewController.swift
//  SnakeSwift
//
//  Created by eandrade21 on 4/7/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import AppKit
import SnakeCommon

class OSX_SnakeGameViewController: NSViewController {

    var snakeGameController: SnakeGameController!
    var stageView: OSX_StageView!
    weak var windowContainer: OSX_MainWindowController?

    init?(gameMode: SnakeGameMode) {
        super.init(nibName: "OSX_SnakeGameViewController", bundle: nil)

        switch gameMode {
        case .SinglePlayer:
            snakeGameController = SinglePlayerSnakeGameController()
        case .MultiPlayerMaster:
            snakeGameController = MultiplayerMasterSnakeGameController()
            MPCController.sharedMPCController.delegate = snakeGameController as MultiplayerSnakeGameController
        case .MultiplayerSlave:
            snakeGameController = MultiplayerSlaveSnakeGameController()
            MPCController.sharedMPCController.delegate = snakeGameController as MultiplayerSnakeGameController
        }

        snakeGameController.viewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.frame = OSX_WindowResizer.resizeWindowProportionalToScreenResolution(0.5)!

        snakeGameController.startGame()
    }

    override func viewWillDisappear() {
        windowContainer?.snakeGame = nil
        windowContainer = nil
    }
}

extension OSX_SnakeGameViewController: SnakeViewController {

    func setUpView() {
        stageView = OSX_StageView(frame: view.bounds)
        stageView.becomeFirstResponder()
        stageView.delegate = self
        view.addSubview(stageView)
        drawViews()
    }

    func drawViews() {
        for (_, elementCollection) in snakeGameController.stage.elements {
            for element in elementCollection {
                drawElement(element)
            }
        }
    }

    func drawElement(element: StageElement) {
        dispatch_async(dispatch_get_main_queue()) {
            self.stageView.drawElement(element)
        }
    }

    func destroy() {
        stageView.resignFirstResponder()
        stageView.delegate = nil
        stageView.removeFromSuperview()
        stageView = nil
    }

    func showModalMessage() {
        stageView.showModalMessage()
    }
}


extension OSX_SnakeGameViewController: InputViewDelegate {
    func processKeyInput(key: String, transform: StageViewTransform) {
        snakeGameController.processKeyInput(key, transform: transform)
    }
}