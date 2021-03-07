//
//  FoodViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

import UIKit
import Firebase

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var FoodNameLabel: UILabel!
    
    @IBOutlet weak var FoodPriceLabel: UILabel!
}

class FoodViewController: UIViewController {

    @IBOutlet weak var foodTableView: UITableView!
    let db = Firestore.firestore()
    
    var foods: [Food] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton=true
        foodTableView.dataSource=self

        loadFood()
    }
    
    func loadFood()
    {
        foods=[]
        
        db.collection(K.fire.foodColection).getDocuments{(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data.  \(e)")
            }
            else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let  foodName = data[K.fire.foodName] as? String, let foodPrice = data[K.fire.foodPrice] as? Float, let foodDescription = data[K.fire.foodDescription] as? String
                        {
                            let newFood = Food(title: foodName, uprice: foodPrice, description: foodDescription)
                            self.foods.append(newFood)
                            
                            DispatchQueue.main.async {
                                self.foodTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

}

extension FoodViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MyCustomCell
        cell.FoodNameLabel.text = foods[indexPath.row].title
        cell.FoodPriceLabel.text = "\(foods[indexPath.row].uprice)"
        return cell
    }
    
    
}
