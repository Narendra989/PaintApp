//
//  MenuViewModel.swift
//  PaintApp
//
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import UIKit

class MenuViewModel: NSObject {
    var colorList = [UIColor]()
    
    func getListOfColors() {
        colorList = PaintColor.getAllColor()
    }
    
    func tableViewCell(tableView: UITableView, indexPath: IndexPath) -> MenuCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstant.MENU_CELL, for: indexPath) as! MenuCell
        let color = colorList[indexPath.row]
        cell.colorView.backgroundColor = color
        return cell
    }
}
