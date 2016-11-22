//
//  MCManager.swift
//  SlinMCPeer
//
//  Created by 蔡祥霖 on 2016/11/22.
//  Copyright © 2016年 woody_tsai. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class MCManager: NSObject , MCSessionDelegate{
	var peerID : MCPeerID? = nil
	var session : MCSession? = nil
	var browser : MCBrowserViewController? = nil
	var advertiesr : MCAdvertiserAssistant?  = nil
	
	func setupPeerAndSesstionWithName(name: NSString){
		self.peerID = MCPeerID(displayName: name as String)
		session = MCSession(peer: peerID!)
		session!.delegate = self
	}
	func setupMCBrowser(){
		browser = MCBrowserViewController(serviceType: "chat-files", session: session!)
	}
	func advertiesSelf(shouldAdverties:Bool){
		if shouldAdverties {
			advertiesr = MCAdvertiserAssistant(serviceType: "chat-files", discoveryInfo: nil, session: session!)
			advertiesr!.start()
		}else{
			advertiesr!.stop()
			advertiesr = nil
		}
	}
	// MARK: - MCSessiontDelegate
	public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
		let dict = ["peerID" : peerID , "state" : state] as [String : Any]

		NotificationCenter.default.post(name: .MCDidChangeStateNotification , object: nil, userInfo: dict)
	}
	public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
	
	}
	public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
	}
	public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
	
	}
	public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
	
	}
	//option
	public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Swift.Void){
	
	}
	
}
extension Notification.Name {
	static let MCDidChangeStateNotification = Notification.Name("MCDidChangeStateNotification")
}

// Usage:
//NotificationCenter.default.post(name: .yourCustomNotificationName, object: nil)
