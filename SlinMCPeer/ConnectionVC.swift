//
//  ConnectionVC.swift
//  SlinMCPeer
//
//  Created by 蔡祥霖 on 2016/11/18.
//  Copyright © 2016年 woody_tsai. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ConnectionVC: UIViewController  {

	@IBOutlet weak var textField: UITextField!
	
	@IBOutlet weak var appearSwitch: UISwitch!
	
	@IBOutlet weak var browseButton: UIButton!
	
	@IBOutlet weak var DisconnectButton: UIButton!
	
	@IBOutlet weak var tableView: UITableView!
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var arrConnectedDevices = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
		appDelegate.mcManager!.setupPeerAndSesstionWithName(name: UIDevice.current.name as NSString)
		appDelegate.mcManager!.advertiesSelf(shouldAdverties: appearSwitch.isOn)
		textField.delegate = self
		NotificationCenter.default.addObserver(forName: .MCDidChangeStateNotification , object: nil, queue: nil){ notify  in
			let dict = notify.userInfo
			let peerID =  dict!["peerID"] as! MCPeerID
			let peerDisplayName = peerID.displayName
			let state = dict!["state"] as! MCSessionState
			
			if state != .connecting {
				if state == .connected {
					self.arrConnectedDevices.append(peerDisplayName)
				}else{

					if let index = self.arrConnectedDevices.index(of: peerDisplayName) {
						self.arrConnectedDevices.remove(at: index)
					}
				}
				self.tableView.reloadData()
				let peersExist = self.appDelegate.mcManager!.session?.connectedPeers.count == 0
				self.DisconnectButton.isEnabled = peersExist
				self.textField.isEnabled = peersExist
				
			}
		}
    }
	
	
	@IBAction func toggleVisibility(_ sender: UISwitch) {
		appDelegate.mcManager!.advertiesSelf(shouldAdverties: sender.isOn)
	}
	
	@IBAction func browseDevice(_ sender: UIButton) {
		appDelegate.mcManager?.setupMCBrowser()
		appDelegate.mcManager?.browser!.delegate = self
		present(appDelegate.mcManager!.browser!, animated: true, completion: nil)
		
	}

	@IBAction func disconect(_ sender: UIButton) {
	}



}
extension ConnectionVC:MCBrowserViewControllerDelegate {
	public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController){
		browserViewController.dismiss(animated: true, completion: nil)
	}
	public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController){
		browserViewController.dismiss(animated: true, completion: nil)
	}
	//option
//	public func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool{
//		return true
//	}
}
extension ConnectionVC:UITextFieldDelegate{
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		resignFirstResponder()
		appDelegate.mcManager!.peerID = nil
		appDelegate.mcManager!.session = nil
		appDelegate.mcManager!.browser = nil
		appDelegate.mcManager!.advertiesSelf(shouldAdverties: false)
		appDelegate.mcManager!.setupPeerAndSesstionWithName(name: textField.text! as NSString)
		appDelegate.mcManager!.setupMCBrowser()
		appDelegate.mcManager!.advertiesSelf(shouldAdverties: appearSwitch.isOn)
		
		return true
	}
}

extension ConnectionVC: UITableViewDelegate , UITableViewDataSource{
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		return self.arrConnectedDevices.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
  		var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
		if (cell == nil) {
			cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
		}
		cell?.textLabel?.text = arrConnectedDevices[indexPath.row]
		return cell!
	}
}
