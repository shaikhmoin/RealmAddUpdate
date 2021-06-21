//
//  ViewController.swift
//  DemoCltnView
//
//  Created by Moin Shaikh on 20/06/21.
//

import UIKit
import RealmSwift
import Realm

class ViewController: UIViewController {

    @IBOutlet weak var cltnList: UICollectionView!
    @IBOutlet weak var cltnHeightConstraints: NSLayoutConstraint!
    
    private let spacing:CGFloat = 12.0
    private let aryCount:Int = 20
    private var totalSum : Int = 0
    
    var objItem = ObjItemDetails()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Fetch Data from Realm
        let arydata = DBManager.sharedInstance.fetchObjects(ObjItemDetails.self, nil, nil)
        print(arydata)
        
        //Insert data into Realm
        let objItems = ObjItemDetails()
        objItems.id = 3
        objItems.courseName = "ios courses"
        objItems.coursePrice = 1200
        print(objItems)
        
        try! realm.write {
            //realm.add(objItems)
        }
        
        //Fetch Data from Realm
        let arydata1 = DBManager.sharedInstance.fetchObjects(ObjItemDetails.self, nil, nil)
        print(arydata1)
        
        var strItemsDet : String!
        var aryValFinal : [AnyObject] = [AnyObject]()

        //Create string format
        for i in 0 ..< arydata1.count {
            strItemsDet = ("{\"ID\":\(arydata1[i].id)" + " , " + "\"CourseName\":\"\(arydata1[i].courseName ?? "")\"" + " , " + "\"coursePrice\":\(arydata1[i].coursePrice)}")
            print(strItemsDet as Any)
            
            //Update into Realm database
//            let objCT = DBManager.sharedInstance.fetchObjects(ObjItemDetails.self, NSPredicate(format: "id = %d", arydata1[i].id), nil).first
//            if objCT != nil{
//                DBManager.sharedInstance.updateObject {
//                    objCT?.courseName = "Edit course name"
//                    objCT?.coursePrice = 1500
//                }
//            }
            
            let arydata1 = DBManager.sharedInstance.fetchObjects(ObjItemDetails.self, nil, nil)
            print(arydata1)
            
            totalSum = totalSum + arydata1[i].coursePrice
            aryValFinal.append(strItemsDet as AnyObject)
        }
        
        print(aryValFinal)
        print(totalSum)
        // let strFinalDT = ("{\"item_package_status\":\(strItemsDet)}}")
//        let finalStr = "{\"move_id\":\(self.objJob.id)" + " , " +  "\"item_package_status\":" + "\(strItemsDet)}}"
//        print(finalStr)
              
        self.setupUI()
    }
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8)
            print(convertedString as Any)
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    //MARK:- Setup UI
    func setupUI() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.cltnList.register(UINib(nibName: "RelatedprodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RelatedprodCollectionViewCell")
        
        let cellSize = (cltnList.frame.size.width / 2) - 10
        let layout: UICollectionViewFlowLayout = (cltnList.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing //Every cell bottom spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellSize, height: cellSize) //same as sizeForItemAt
        
        cltnList.delegate = self
        cltnList.dataSource = self
        cltnList.showsHorizontalScrollIndicator = false
        cltnList.showsVerticalScrollIndicator = false
    }
    
    //MARK:- Collectionview height calculation
    func setupCltnHeight(cltnHeight:CGFloat) {
        if aryCount % 2 == 0 {
            cltnHeightConstraints.constant = (cltnHeight * (CGFloat(aryCount)/2)) + (CGFloat(aryCount)/2 * spacing) + spacing
        } else {
            cltnHeightConstraints.constant = (cltnHeight * (CGFloat(aryCount)/2)) + (CGFloat(aryCount)/2 * spacing) + spacing + cltnHeight / 2
        }
        // cltnHeightConstraints.constant = (cltnHeight * (CGFloat(aryCount)/2)) + 72 //)Cltnheight = Actual height * aryCount / 2) + (aryCount / 2*spacing) + spacing
    }
    
    //MARK:- BNutton Add To Cart
    @IBAction func btnAddToCart(_ sender: Any) {
        let nav = self.storyboard?.instantiateViewController(identifier: "idShoppingCartViewController") as! ShoppingCartViewController
        nav.sum = totalSum
        self.navigationController?.pushViewController(nav, animated: true)
    }
}

//MARK:- Collection view flow layout
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = self.spacing
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.cltnList{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            
            //Cltn height setup (width + 20 = Both)
            setupCltnHeight(cltnHeight: width)
            return CGSize(width: width, height: width)
            
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}

//MARK:- Collection view datasource
extension ViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedprodCollectionViewCell",for:indexPath) as! RelatedprodCollectionViewCell
        
        cell.lblVal.text = String(indexPath.row + 1)
        
        return cell
    }
}
