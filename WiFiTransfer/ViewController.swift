//
//  ViewController.swift
//  WiFiTransfer
//
//  Created by zhouqi on 2019/8/20.
//  Copyright © 2019 zhouqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var webServer = GCDWebUploader()
    var fileNameArr = [String]()
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTableView()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        webServer = GCDWebUploader(uploadDirectory: documentsPath)
        webServer.allowedFileExtensions = ["doc", "docx", "xls", "xlsx", "txt", "pdf", "png", "epub"]
        webServer.title = "全能文件阅读器";
        webServer.prologue = "欢迎使用全能文件阅读器WIFI管理平台";
        webServer.epilogue = "";
        webServer.footer = "全能文件阅读器";
        webServer.delegate = self
        if webServer.start() {
            self.ipLabel.text = "传输地址：" + (webServer.serverURL?.absoluteString ?? "")
        } else {
            self.ipLabel.text = "服务启动失败请退出重新打开"
        }
    }
    
    func refreshTableView() {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            self.fileNameArr = try! FileManager.default.contentsOfDirectory(atPath: path)
            self.tableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: GCDWebUploaderDelegate {
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        print(path)
        refreshTableView()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print(path)
        refreshTableView()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didCreateDirectoryAtPath path: String) {
        print(path)
        refreshTableView()
    }
    
    func webUploader(_ uploader: GCDWebUploader, didMoveItemFromPath fromPath: String, toPath: String) {
        print(fromPath)
        print(toPath)
        refreshTableView()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = self.fileNameArr[indexPath.row];
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
