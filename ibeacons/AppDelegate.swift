//
//  AppDelegate.swift
//  ibeacons
//
//  Created by Liam Williams on 2016-08-16.
//  Copyright © 2016 Lighthouse. All rights reserved.
//
//  iBeacons Demo Project for Lighthouse Labs
//  Remember: Set NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription in info.plist

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Remember instance of location manager must be stored somewhere where it will not be deallocated before
    // permission request, and location operations are complete (don't store it in a method variable)
    let locationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.delegate = self
        
        // Always Authorization for monitoring beacons in background
        // While in use Authorization for moitoring for beacons and ranging beacons in foreground
        locationManager.requestAlwaysAuthorization()
        
        //Local Notification permission to show beacon monitoring in background
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Sound, .Alert, .Badge], categories: nil))
        
        return true
    }
}

extension AppDelegate : CLLocationManagerDelegate {
    
    //Wait until permission is allowed to start listening for beacons
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("got permission")
        if status == .AuthorizedAlways {
            if let uuid = NSUUID(UUIDString: "0248BD99-1141-4347-9B2C-FFE34F92C405") {
                let region = CLBeaconRegion(proximityUUID: uuid, identifier: "")
                locationManager.startRangingBeaconsInRegion(region)
            }
        }
    }
    
    // Confirm that we starting monitoring successfully
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("starting monitoring for region")
    }
    
    //Failure delegate methods for region monitoring and general location manager errors
    // Will not fire if you have not set NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Failed monitoring region: \(error.description)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location manager failed: \(error.description)")
    }
    
    //Saw this beacon, ie. entering its region
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter Region")
        let notification = UILocalNotification()
        notification.alertBody = "Welcome :)"
        notification.soundName = "Default"
        window?.rootViewController?.view.backgroundColor = UIColor.greenColor()
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //Haven't seen this beacon for a while (20s ish?), ie. exiting its region
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Region")
        let notification = UILocalNotification()
        notification.alertBody = "Goodbye :)"
        notification.soundName = "Default"
        window?.rootViewController?.view.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //Ranging beacons delegate method, shows more details about the beacon, including identifiers and distance
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if let beacon = beacons.first {
            print(nameForProximity(beacon.proximity))
        }
    }
    
    func nameForProximity(proximity: CLProximity) -> String {
        switch proximity {
        case .Unknown:
            //Not found or unkown
            window?.rootViewController?.view.backgroundColor = UIColor.redColor()
            return "Unknown"
        case .Immediate:
            //About a few centimeters
            window?.rootViewController?.view.backgroundColor = UIColor.greenColor()
            return "Immediate"
        case .Near:
            //About A few meters
            window?.rootViewController?.view.backgroundColor = UIColor.blueColor()
            return "Near"
        case .Far:
            //About greater than 10 meters
            window?.rootViewController?.view.backgroundColor = UIColor.yellowColor()
            return "Far"
        }
    }
}

