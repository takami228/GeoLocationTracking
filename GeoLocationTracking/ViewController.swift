//
//  ViewController.swift
//  GeoLocationTracking
//
//  Created by takami228 on 2018/02/04.
//  Copyright © 2018年 takami228. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet var googleMap: GMSMapView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var marker: GMSMarker!
    var zoom: Float!
    var isTracking: Bool!
    var distance: Double!
    var preLocation: CLLocation!
    var timer: Timer!
    var startTime: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DGSLogv("%@", getVaList(["DG Start App"]))
        
        locationManager = CLLocationManager()
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        
        zoom = 14.5
        googleMap.camera = GMSCameraPosition.camera(withLatitude: 35.68154, longitude: 139.752498, zoom: zoom)
        googleMap.settings.myLocationButton = true
        preLocation = CLLocation(latitude: 35.68154, longitude: 139.752498)
        marker = GMSMarker(position: CLLocationCoordinate2DMake(35.68154, 139.752498))
        marker.title = "皇居"
        marker.map = googleMap
        
        distance = 0
        distanceLabel.text = String(self.distance.rounded()) + " m"
        timerLabel.text = "0"
        timer = Timer()
        startTime = 0.0
        isTracking = false;
    }

    @IBAction func touchButton(_ sender: Any) {
        if(isTracking){
            button.setTitle("開始", for: .normal)
            button.backgroundColor = UIColor.cyan

            isTracking = false
            distanceLabel.text = String(distance.rounded()) + " m"
            
            timer.invalidate()
        } else {
            button.setTitle("停止", for: .normal)
            button.backgroundColor = UIColor.magenta
            
            isTracking = true
            distance = 0
            distanceLabel.text = String(distance.rounded()) + " m"

            timerLabel.text = "0"
            startTime = Date().timeIntervalSince1970
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(ViewController.timerUpdate),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc func timerUpdate(){
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss.S"
        timerLabel.text = formatter.string(from: (now - startTime))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            //ユーザに許可を求める
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            locationManager.stopUpdatingLocation()
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            locationManager.stopUpdatingLocation()
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            //位置情報の取得を開始する
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            let now = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            zoom = googleMap.camera.zoom
            googleMap.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                        longitude: location.coordinate.longitude,
                                                        zoom: zoom)
            marker.position = location.coordinate
            marker.title = "Your are here"
            marker.map = googleMap
            if(isTracking){
                distance = distance + preLocation.distance(from: now)
                distanceLabel.text = String(distance.rounded()) + " m"
            }
            preLocation = now
        }
    }
}
