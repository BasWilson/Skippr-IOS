//
//  uihandling.swift
//  Skippr
//
//  Created by Bas Wilson on 18/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit


//TEXT FIELD
class TextField: UITextField {
    
	
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

class UIHandling : UIViewController {
    
    func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.clear
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    

}
