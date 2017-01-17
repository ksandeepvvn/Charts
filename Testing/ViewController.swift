//
//  ViewController.swift
//  Testing
//
//  Created by admin on 05/01/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SocketIO
import UserNotifications
import UserNotificationsUI
import RealmSwift



@available(iOS 10.0, *)
class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var showGraph: UIButton!
    
    @IBOutlet weak var text1: UILabel!
    
    @IBOutlet weak var text2: UILabel!
    
 let socket = SocketIOClient(socketURL: URL(string: "http://ios-test.us-east-1.elasticbeanstalk.com/")!, config: [.log(true), .forcePolling(true)])
    var numberss: Int? = nil
    var breakNumber: Int? = nil
   
    let requestIdentifier = "SampleRequest"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text1.isHidden = false
        self.text2.isHidden = false
    showGraph.isHidden = true
        socket.joinNamespace("/random")
        addHandlers()
        socket.connect()
         socket.on("connect") {data, ack in
            print("socket connected")
        }
        socket.on("Disconnect") { (data, ack) in
            print("disconnect")
            self.socket.removeAllHandlers()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHandlers()
    {
        socket.on("capture") { ( data, ack) -> Void in
            print("Data Comming is:", data[0])
            if self.numberss == data[0] as? Int
            {
                print("Redundent Number")
                self.socket.disconnect()
                self.breakNumber = 1
            }
            if self.breakNumber == 1
            {
                self.triggerNotification(Number: self.numberss!)
                self.socket.disconnect()
            }
            else{
                self.numberss = data[0] as? Int
                let numberCount = NumberCount()
                numberCount.count = self.numberss!
                numberCount.save()
            }
        }
    }
func triggerNotification(Number: Int)
    {
        print("notification will be triggered in four seconds..Hold on tight")
        let content = UNMutableNotificationContent()
        content.title = "Triggerd Same Number"
        content.subtitle = "Just To Show How Notification Works"
        content.body = "Triggered Same Number Twice"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "monkey", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in two seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 4.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func stopNotification()
    {
        print("Removed all pending notifications")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
    }
    }
@available(iOS 10.0, *)
extension ViewController:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Tapped in notification")
    }
    
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification being triggered")
        if notification.request.identifier == requestIdentifier{
            completionHandler( [.alert,.sound,.badge])
        self.showGraph.isHidden = false
            self.text1.isHidden = true
            self.text2.isHidden = true
        }
    }
}
