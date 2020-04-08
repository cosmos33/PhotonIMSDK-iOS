//
//  PhotonFilePreviewViewController.swift
//  PhotonIM
//
//  Created by Bruce on 2020/3/17.
//  Copyright © 2020 Bruce. All rights reserved.
//

import UIKit
import QuickLook
final class PhotonFilePreviewItem:NSObject{
    public var itemURL:URL?
    public var itemTitle:String?
    
}
extension PhotonFilePreviewItem:QLPreviewItem{
    var previewItemURL: URL? {
        return self.itemURL
    }
    var previewItemTitle: String?{
        return self.itemTitle
    }
    
    
}

final class PhotonFilePreviewViewController: UIViewController  {
    public var filePath:URL!
    public var userData:Any!
    private var previewController:QLPreviewController!;
    private var item:PhotonFilePreviewItem!
    @objc public init(url:URL,title:String) {
        item = PhotonFilePreviewItem();
        item?.itemURL = url
        item?.itemTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.previewController = QLPreviewController();
        self.previewController.delegate = self;
        self.previewController.dataSource = self;
        self.addChild(self.previewController);
        self.view.addSubview(self.previewController.view);
        self.previewController.view.frame = self.view.bounds;
    }

}
extension PhotonFilePreviewViewController: QLPreviewControllerDelegate,QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
          return 1;
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.item
    }
    
   
}
