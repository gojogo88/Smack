//
//  ChannelVC.swift
//  Smack
//
//  Created by Jonathan Go on 2017/08/31.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CIrcleImage!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelID != MessageService.instance.selectedChannel?.channelID && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelID)
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }

    //will show the xib addChannel
    @IBAction func addChannelBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        } else {
            print("you are not logged in")
        }
    }
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            //show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification){
        tableView.reloadData()
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    //select a channel, save it to the messageservice selectedchannel,notify the chatvc that we have selected a channel then close the menu
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        //check if there are unread channels then filter out this channel from the unread channels then reload it (so its now not an unread channel) then we are going to reselect it to bring it back to normal.
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.channelID}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
}
