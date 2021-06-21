//
//  CartViewController.swift
//  DemoCltnView
//
//  Created by Moin Shaikh on 20/06/21.
//

import UIKit
import RealmSwift
import Realm

class ShoppingCartViewController: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet var tblBottom: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var aryItems = [ObjItemDetails]()
    var sum : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Moin Shaikh
        self.setupUI()
    }
    
    //MARK:- Setup UI
    func setupUI() {
        
        aryItems = DBManager.sharedInstance.fetchObjects(ObjItemDetails.self, nil, nil)
        print(aryItems)
        print(aryItems.count)
        
        lblTotalPrice.text = "$ " + String(sum)
        self.tblList.register(UINib(nibName: "ShoppingCartTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartTableViewCell")
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.tableFooterView = tblBottom
    }
    
    //MARk:- Button back click
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Tableview delegate
extension ShoppingCartViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let settingVCObj = self.storyboard?.instantiateViewController(withIdentifier: "idItemDetailsVC") as! ItemDetailsVC
//        //wishlistVCObj.isFromMenu = true
//        self.navigationController?.pushViewController(settingVCObj, animated: true)
    }
}

extension ShoppingCartViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartTableViewCell") as! ShoppingCartTableViewCell
        
        let objitem = aryItems[indexPath.row]
        cell.lblCount.text = String(indexPath.row + 1)
        cell.lblTitle.text = objitem.courseName
        cell.lblPrice.text = "$ " + String(objitem.coursePrice)
//        cell?.lblDesc.text = arrMenuDet[indexPath.row]
//        cell?.imgMenu.image = UIImage(named: arrMenuImg[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
