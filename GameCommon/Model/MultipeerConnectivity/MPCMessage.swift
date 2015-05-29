//
//  MPCMessage.swift
//  GameSwift
//
//  Created by eandrade21 on 4/24/15.
//  Copyright (c) 2015 PartyLand. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public enum MPCMessageEvent: Int32 {
    case TestMsg
    case ShowGameViewController
    case DidShowGameViewController
    case InitPlayer
    case ScheduleGame
    case EndGame

}

public enum MPCMessageKey: String {
    case Sender = "sndK"
    case Receiver = "rxrK"
    case TestMsgBody = "tstMsgBdyK"
    case Event = "evtK"
    case Body = "bdyK"
    case GameStartDate = "gamStrDatK"
    case PlayerConfig = "plyCfgK"

    // Locatable
    case Locations = "locK"
    case LocationX = "locXK"
    case LocationY = "locY"

    // Player
    case PlayerDirection = "dirK"
    case PlayerType = "typK"

}

protocol GameMessages {
    func testMessage(message: MPCMessage)
    func initPlayerMessage(message: MPCMessage)
    func didShowGameViewController(message: MPCMessage)
}

public class MPCMessage: NSObject, NSCoding {

    public var event: MPCMessageEvent
    public var sender: MCPeerID
    public var body: [String : AnyObject]?

    init(event: MPCMessageEvent, body: [String : AnyObject]?) {
        self.event = event
        self.sender = MPCController.sharedMPCController.peerID
        self.body = body

        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt32(event.rawValue, forKey: MPCMessageKey.Event.rawValue)
        aCoder.encodeObject(sender, forKey: MPCMessageKey.Sender.rawValue)

        if let _body = body {
            aCoder.encodeObject(_body, forKey: MPCMessageKey.Body.rawValue)
        }

    }

    required public init(coder aDecoder: NSCoder) {
        self.event = MPCMessageEvent(rawValue: aDecoder.decodeInt32ForKey(MPCMessageKey.Event.rawValue))!
        self.sender = aDecoder.decodeObjectForKey(MPCMessageKey.Sender.rawValue) as MCPeerID

        if let body = aDecoder.decodeObjectForKey(MPCMessageKey.Body.rawValue) as? [String : AnyObject] {
            self.body = body
        }
        super.init()
    }

    func serialize() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }

    class func deserialize(data: NSData) -> MPCMessage? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? MPCMessage
    }

    class func getMessageHandler(message: MPCMessage) -> (GameMessages) -> Void {
        switch message.event {
        case .TestMsg:
            return {(delegate: GameMessages) in delegate.testMessage(message)}
        case .InitPlayer:
            return {(delegate: GameMessages) in delegate.initPlayerMessage(message)}
        case .DidShowGameViewController:
            return {(delegate: GameMessages) in delegate.didShowGameViewController(message)}
        default:
            return {(delegate: GameMessages) in assertionFailure("Message has unknown handler")}
        }
    }
}

extension MPCMessage {

    public class func getTestMessage(body: String) -> MPCMessage {
        let body: [String : AnyObject] = [MPCMessageKey.TestMsgBody.rawValue : body]

        return MPCMessage(event: MPCMessageEvent.TestMsg, body: body)
    }

    public class func getShowGameViewControllerMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.ShowGameViewController, body: nil)
    }

    public class func getDidShowGameViewControllerMessage() -> MPCMessage {
        return MPCMessage(event: MPCMessageEvent.DidShowGameViewController, body: nil)
    }
    public class func getInitPlayerMessage(playerConfig: PlayerConfiguration) -> MPCMessage {

        let body: [String : AnyObject] = [MPCMessageKey.PlayerConfig.rawValue : playerConfig]

        return MPCMessage(event: MPCMessageEvent.InitPlayer, body: body)
    }

    public class func getScheduleGameMessage(gameStartDate: String)  -> MPCMessage {

        let body: [String : AnyObject] = [MPCMessageKey.GameStartDate.rawValue : gameStartDate]

        return MPCMessage(event: MPCMessageEvent.ScheduleGame, body: body)
    }
}