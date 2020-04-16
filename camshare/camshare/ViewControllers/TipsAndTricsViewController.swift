//
//  TipsAndTricsViewController.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/04/07.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit
import camPod

class TipsAndTricsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tipsTricsTableView: UITableView!
    var tableView: UITableView!
    var tipsAndTricksContent = [TipsAndTricksModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)

        let celNib = UINib(nibName: "TipsAndTricsTableViewCell", bundle: nil)
        tableView.register(celNib, forCellReuseIdentifier: "tipsAndTricsCell")

        var layoutGuide: UILayoutGuide!
        layoutGuide = view.safeAreaLayoutGuide

        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self

        let viewModel = TipsAndTricsViewModel()
        viewModel.getTipsTricks(request: "tipsandtricks") { (result) in
            self.tipsAndTricksContent = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func statusChanged(_ sender: UISegmentedControl!) {
        let viewModel = TipsAndTricsViewModel()
        let status = sender.selectedSegmentIndex
        if status == 0 {
            viewModel.changeStatus(status: "updatestatusnew",
                                   model: tipsAndTricksContent[sender.tag]) { (model) in
                                    self.tipsAndTricksContent[sender.tag] = model
                                    self.tableView.reloadData()
            }
        }

        if status == 1 {
            viewModel.changeStatus(status: "updatestatustried",
                                   model: tipsAndTricksContent[sender.tag]) { (model) in
                                    self.tipsAndTricksContent[sender.tag] = model
                                    self.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsAndTricksContent.count
    }

    //swiftlint:disable all
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tipsAndTricsCell", for: indexPath) as! TipsAndTricsTableViewCell
    //swiftlint:enable all
        cell.headingLabel.text = tipsAndTricksContent[indexPath.item].heading
        cell.bodyTextView.text = tipsAndTricksContent[indexPath.item].body
        cell.statusSegmentControl.tag = indexPath.row
        cell.statusSegmentControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
        return cell
    }
    
}
