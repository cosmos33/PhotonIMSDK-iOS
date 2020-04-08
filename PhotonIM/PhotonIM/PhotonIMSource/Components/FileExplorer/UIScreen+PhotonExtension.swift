//
//  UIScreen+PhotonExtension.swift
//  PhotonIM
//
//  Created by Bruce on 2020/3/18.
//  Copyright © 2020 Bruce. All rights reserved.
//

import UIKit

extension UIScreen {

    func widthOfSafeArea() -> CGFloat {

        guard let rootView = UIApplication.shared.keyWindow else { return 0 }

        if #available(iOS 11.0, *) {

            let leftInset = rootView.safeAreaInsets.left

            let rightInset = rootView.safeAreaInsets.right

            return rootView.bounds.width - leftInset - rightInset

        } else {

            return rootView.bounds.width

        }

    }

    func heightOfSafeArea() -> CGFloat {

        guard let rootView = UIApplication.shared.keyWindow else { return 0 }

        if #available(iOS 11.0, *) {

            let topInset = rootView.safeAreaInsets.top

            let bottomInset = rootView.safeAreaInsets.bottom

            return rootView.bounds.height - topInset - bottomInset

        } else {

            return rootView.bounds.height

        }

    }
    
    func widthOfSafeAreaInsetsBottom() -> CGFloat {

        guard let rootView = UIApplication.shared.keyWindow else { return 0 }

        if #available(iOS 11.0, *) {
           return rootView.safeAreaInsets.bottom
        } else {

            return 0

        }

    }

}
