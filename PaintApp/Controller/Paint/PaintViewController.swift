//
//  PaintViewController.swift
//  PaintApp
//  Used to draw pattern 
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import UIKit
import CoreLocation

class PaintViewController: UIViewController, SelectedColorProtocol, CLLocationManagerDelegate {
    //MARK: Properties
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuBtnLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var menuLeadingConstraints: NSLayoutConstraint!
    
    var isMenuOpen = true
    var menuController: MenuViewController?
    
    //MARK: Constants
    let paintViewModel = PaintViewModel()
    var locationManager:CLLocationManager!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setupLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
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
    
    //MARK: - Location Manager Delegate method
    
    private func locationManager(manager: CLLocationManager!, didUpdateHeading heading: CLHeading!) {
        // This will print out the direction the device is heading
        print(heading.magneticHeading)
        
    }
}

