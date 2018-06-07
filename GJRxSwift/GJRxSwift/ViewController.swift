//
//  ViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    struct Project {
        let title:String
        
        init(title:String) {
            self.title = title
        }
    }
    
    struct ProjectListModel {
        let data = Observable.just([
            Project(title:"Observable介绍、创建可观察序列"),
            Project(title:"Observable订阅、事件监听、订阅销毁")
        ])
    }
    
    lazy var tableView:UITableView? = {
        let tableView = UITableView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "projectCell")
        return tableView
    }()
    
    let projectListModel = ProjectListModel()
    
    //负责销毁对象
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "RxSwift"
        
        view.addSubview(tableView!)
        //将数据源绑定到tableview上
        projectListModel.data.bind(to: (tableView?.rx.items(cellIdentifier: "projectCell"))!) {_, project, cell in
            cell.textLabel?.text = project.title
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView?.rx.itemSelected.subscribe(onNext : {indexPath in
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(ObservableIntroduceCreateViewController(), animated: true)
            }else if indexPath.row == 1 {
                self.navigationController?.pushViewController(ObservableSubscribeDoonDisposeViewController(), animated: true)
            }
        }).disposed(by: disposeBag)
    }

}
