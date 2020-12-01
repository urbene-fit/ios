//
//  TestTableViewController.swift
//  welfare
//
//  Created by 김동현 on 2020/08/04.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class TestTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let menus = ["swift","tableview","example"]
    let images = ["welfare","welfare2","welfare3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
                        
        tableView.dataSource = self
        tableView.delegate = self

        self.tableView.estimatedRowHeight = 500
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TestTableViewController: UITableViewDataSource{
    
    // table row 갯수 (menu 배열의 갯수만큼)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return menus.count

    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavorCell", for: indexPath) as! FavorCell
         
        
        cell.textView?.text = menus[indexPath.row]
        cell.imgView?.image = UIImage(named: images[indexPath.row])
       
         
         return cell
    }
    
    //테이블 뷰 높이지정

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 200
      }
    
}



