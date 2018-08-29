//
//  PaintViewController.swift
//  PaintApp
//  Used to draw pattern 
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class PaintViewController: UIViewController, SelectedColorProtocol,CLLocationManagerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var rotateImage: UIImageView!
    
    @IBOutlet weak var startBtn: UIBarButtonItem!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuBtnLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var menuLeadingConstraints: NSLayoutConstraint!
    
    
    var latestLocation: CLLocation? = nil
    var yourLocation = CLLocation(latitude: 90, longitude: 0)
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        
        return $0
    }(CLLocationManager())
    
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    var isMenuOpen = true
    var menuController: MenuViewController?
    
    //MARK: Constants
    let paintViewModel = PaintViewModel()
    let manager = CMMotionManager()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupDeviceMotion()
        locationManager.delegate = self
        paintViewModel.loadView(view: self.view)
        menuLeadingConstraints.constant = 0
        menuBtnLeadingConstraints.constant = 50
        menuBtn.isSelected = true
        self.view.bringSubview(toFront: menuContainerView)
        self.view.bringSubview(toFront: menuBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = SharedAppStorage.shared.getStoredImage() {
            SharedAppStorage.shared.selectedImage = image
            paintViewModel.showImageOnCanvas(image: image)
            SharedAppStorage.shared.clearStoredData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager.stopAccelerometerUpdates()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintViewModel.touchBegin(touches, view: self.view)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       paintViewModel.touchMoved(touches, view: self.view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintViewModel.touchEnded(touches, view: self.view)
        
    }
   
   // Open Side Menu
    @IBAction func openMenu(_ sender: Any) {
        if !isMenuOpen {
            menuLeadingConstraints.constant = 0
            menuBtnLeadingConstraints.constant = 50
            isMenuOpen = true
            menuBtn.isSelected = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else{
           closeMenu()
        }
    }
    
    //MARK: - Selected Color Delegate method

    func didSelectedColor(color: UIColor) {
        closeMenu()
        paintViewModel.changeBrushSize(size: 5.0)
        paintViewModel.changeLineColor(color: color)
    }
    
    func didSelectEraser() {
        closeMenu()
        paintViewModel.changeBrushSize(size: 20.0)
        paintViewModel.changeLineColor(color: UIColor.white)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuView" {
            menuController = segue.destination as? MenuViewController
            menuController?.delegate = self
        }
    }
     // Close Side Menu
    func closeMenu() {
        menuLeadingConstraints.constant = AppConstant.MENU_CELL_WIDTH
        menuBtnLeadingConstraints.constant = 0
        isMenuOpen = false
        menuBtn.isSelected = false
    }
    
    @IBAction func clearBtnAction(_ sender: Any) {
        
        paintViewModel.clearDrawing()
        if SharedAppStorage.shared.selectedImage != nil {
            SharedAppStorage.shared.selectedImage  = nil
        }
        
    }
    
    @IBAction func startDeviceMotion(_ sender: Any) {
        if startBtn.title! == AppConstant.START_TITLE {
           paintViewModel.startDeviceRotation(rotateImage: rotateImage, actionBtn: startBtn, locationManager: locationManager)
        }
        else{
            paintViewModel.stopDeviceRotation(rotateImage: rotateImage, actionBtn: startBtn, locationManager: locationManager)
        }
        
    }
    
    func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
        let heading: CGFloat = {
            let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
            switch UIDevice.current.orientation {
            case .faceDown: return -originalHeading
            default: return originalHeading
            }
        }()
        
        return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
    }
    
    //MARK:- Location Manager Delegate Method
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
       
        UIView.animate(withDuration: 0.5) {
            let angle = CGFloat(newHeading.trueHeading) // convert from degrees to radians
            let angle1 = self.computeNewAngle(with: angle)
            self.rotateImage.transform = CGAffineTransform(rotationAngle: angle1)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latestLocation = locations.last
    }
    
}

