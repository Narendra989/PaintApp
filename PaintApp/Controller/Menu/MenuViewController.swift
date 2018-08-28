//
//  MenuViewController.swift
//  PaintApp
//   Show Slider Menu View
//  Created by Narendra Satpute on 28/08/18.
//  Copyright © 2018 Digi. All rights reserved.
//

import UIKit

protocol SelectedColorProtocol {
    // protocol definition
    func didSelectedColor(color: UIColor)
    func didSelectEraser()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var eraserBtn: UIButton!
    
    //MARK: Constants
    let menuViewModel = MenuViewModel()
    
    var delegate: SelectedColorProtocol?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = AppConstant.MENU_CELL_HEIGHT
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib.init(nibName: AppConstant.MENU_CELL, bundle: nil), forCellReuseIdentifier: AppConstant.MENU_CELL)
        menuTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuViewModel.getListOfColors()
        menuTableView.reloadData()
    }
    //MARK: UITableView Delegate and data source method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewModel.colorList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuViewModel.tableViewCell(tableView: tableView, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = menuViewModel.colorList[indexPath.row]
        delegate?.didSelectedColor(color: color)
    }
    
    @IBAction func eraserBtnAction(_ sender: Any) {
        delegate?.didSelectEraser()
    }    
}
