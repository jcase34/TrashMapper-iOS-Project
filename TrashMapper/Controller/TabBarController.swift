//
//  TabBarController.swift
//  TrashMapper
//
//  Created by Jacob Case on 10/26/22.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = FormUtlities.mainColor
        UITabBar.appearance().unselectedItemTintColor = FormUtlities.mainColor
        
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
