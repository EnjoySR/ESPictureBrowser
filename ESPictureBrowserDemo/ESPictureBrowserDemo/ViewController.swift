//
//  ViewController.swift
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/15.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {
    
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// 数据
    lazy var datas: [[ESPictureModel]] = {
        // 获取数据
        let url = Bundle.main.url(forResource: "list.json", withExtension: nil)!
        let data = try! Data(contentsOf: url)
        let array = try! JSONSerialization.jsonObject(with: data, options: []) as! [[[String: Any]]]
        
        var result = [[ESPictureModel]]()
        // 遍历字典转模型
        for value in array {
            
            var arrayM = [ESPictureModel]()
            for dict in value {
                let model = ESPictureModel()
                model.setValuesForKeys(dict)
                arrayM.append(model)
            }
            result.append(arrayM)
        }
        return result
    }()
    
    lazy var tableView: ASTableView = {
        let tableView = ASTableView()
        tableView.asyncDelegate = self
        tableView.asyncDataSource = self
        return tableView
    }()
}

extension ViewController: ASTableViewDataSource, ASTableViewDelegate {
    
    func tableView(_ tableView: ASTableView, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cellNode = ESCellNode()
        let model = datas[indexPath.row]
        cellNode.configurModel(pictureModels: model)
        return cellNode
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


