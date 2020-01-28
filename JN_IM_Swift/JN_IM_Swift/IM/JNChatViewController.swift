//
//  JNChatViewController.swift
//  JN_IM_Swift
//
//  Created by Jonathan on 2019/12/2.
//  Copyright © 2019 Jonathan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private var JNChatMessageTypeRevoke: JNChatMessageType = "JNCHAT_MSG:REVOKE"

class JNChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: - public property -
    weak public var delegate: JNChatViewDelegate? {
        willSet {
            self.inputBar.delegate = newValue
        }
    }
    
    public var messageArray:[JNChatBaseMessage] = []
    
    //MARK: - public method -
    //注册自定义消息类型
    public func registerCellClass(cellClass:JNChatBaseMessageCell.Type, messageType:JNChatMessageType){
        self.cellClasses[messageType] = cellClass
    }
    
    public func registerRevokeCellClass(cellClass:JNChatBaseMessageCell.Type){
        self.revokeCellClass = cellClass
    }
    
    public func loadWithMessages(messages:[JNChatBaseMessage]){
        self.messageArray = messages
        self.tableView.reloadData()
    }
    //添加新消息
    public func appendMessages(messages:[JNChatBaseMessage]){
        let index = self.messageArray.count - 1
        self.messageArray.append(contentsOf: messages)
        self.reloadTable(fromIndex: index + 1, count: messages.count)
    }
    
    public func scrollToBottom(animated:Bool){
        guard self.messageArray.count != 0 else {
            return
        }
        let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    //MARK: - private -
    private var cellClasses:[JNChatMessageType:JNChatBaseMessageCell.Type] = [JNChatMessageTypeText:JNChatTextMessageCell.self,
                                                                              JNChatMessageTypeImage:JNChatImageMessageCell.self,
                                                                              JNChatMessageTypeUnknow:JNChatUnknowMessageCell.self]
    
    private var revokeCellClass:JNChatBaseMessageCell.Type = JNChatRevokeMessageCell.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerRevokeCellClass(cellClass: JNChatRevokeMessageCell.self)
        self.setupSubViews()
        self.addSubConstraints()
    }
    
    private func setupSubViews(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.inputBar)
        self.tableView.panGestureRecognizer.addTarget(self, action: #selector(tableViewGestureAct(gesture:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewGestureAct(gesture:)))
        self.tableView.addGestureRecognizer(tapGesture)
    }
    
    private func addSubConstraints(){
        self.inputBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(self.inputBar.inputBarHeight)
            make.top.equalTo(self.tableView.snp.bottom)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
        }
        self.view.updateConstraintsIfNeeded()
        weak var weakSelf = self
        self.inputBar.inputBarHeightChange = {(height: CGFloat, inputBar: JNChatInputBar) in
            inputBar.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            weakSelf?.view.layoutIfNeeded()
            weakSelf?.scrollToBottom(animated: false)
        }
    }

    
    private func reloadTable(fromIndex:Int, count:Int){
        self.tableView.beginUpdates()
        var indexPaths:[IndexPath] = []
        for index in stride(from: fromIndex, to: fromIndex + count, by: 1) {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        self.tableView.insertRows(at: indexPaths, with: .none)
        self.tableView.endUpdates()
    }
    
    @objc private func tableViewGestureAct(gesture:UIGestureRecognizer){
        if gesture.isKind(of: UITapGestureRecognizer.self) || gesture.state == .began{
            self.inputBar.takeBackInputBar()
        }
    }
    
//MARK:  - table view delegate -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if  indexPath.row < self.messageArray.count{
            let message = self.messageArray[indexPath.row]
            if message.revoke {
                cell = tableView.dequeueReusableCell(withIdentifier: JNChatMessageTypeRevoke)
                if cell == nil {
                    cell = self.revokeCellClass.init(owns: message.owns, reuseIdentifier: JNChatMessageTypeRevoke)
                    (cell as! JNChatBaseMessageCell).chatController = self
                }
            }
            else{
                var rid = message.messageType
                if message.messageType != JNChatMessageTypeUnknow {
                    if message.owns == .owner {
                        rid += "_Owner"
                    }
                    else if message.owns == .others{
                        rid += "_Others"
                    }
                }
                cell = tableView.dequeueReusableCell(withIdentifier: rid)
                if cell == nil {
                    if let cl = self.cellClasses[message.messageType]{
                        cell = cl.init(owns: message.owns , reuseIdentifier: rid)
                        (cell as! JNChatBaseMessageCell).chatController = self
                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if  indexPath.row < self.messageArray.count {
            let message = self.messageArray[indexPath.row]
            (cell as! JNChatBaseMessageCell).updateWithMessgae(message: message)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row < self.messageArray.count {
            let message = self.messageArray[indexPath.row]
            return message.getTotolHeight()
        }
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.row < self.messageArray.count {
            let message = self.messageArray[indexPath.row]
            return message.getTotolHeight()
        }
        return 0.01;
    }
    
    
//MARK: - lazy load -
    
    lazy var tableView:UITableView = {
        let tempTable = UITableView(frame:CGRect.zero, style:.plain)
        tempTable.delegate = self
        tempTable.dataSource = self
        tempTable.separatorStyle = .none
        tempTable.showsVerticalScrollIndicator = false
        return tempTable
    }()
    
    lazy var inputBar: JNChatInputBar = {
        let temp = JNChatInputBar()
        return temp
    }()
}
