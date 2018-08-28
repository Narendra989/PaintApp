//
//  AppStorage.swift
//  PaintApp
//
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import Foundation
import UIKit

class AppStorage {
    //Mark: - Constants
    static let shared = AppStorage()
    let userDefaults = UserDefaults.standard
    
    var selectedImage: UIImage?
    
    private init(){
    }
    
    func storeImage() {
        if let mainImage = selectedImage {
            let imageData = UIImagePNGRepresentation(mainImage)
            userDefaults.setValue(imageData, forKeyPath: AppConstant.STORE_IMAGE)
            userDefaults.synchronize()
        }
    }
    
    func getStoredImage() -> UIImage?{
        if let data = userDefaults.value(forKey: AppConstant.STORE_IMAGE){
            if let image = UIImage(data:data as! Data){
                 return image as? UIImage
            }
        }
        return nil
    }
    
    func clearStoredData(){
        userDefaults.setValue(nil, forKeyPath: AppConstant.STORE_IMAGE)
        userDefaults.synchronize()
    }
}
