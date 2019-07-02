//
//  ViewController.swift
//  Browser
//
//  Created by Dam Thieu Quang on 5/31/19.
//  Copyright © 2019 Dam Thieu Quang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func showBrowser(_ sender: Any) {
        let browser = WebViewController()
        self.present(browser, animated: true, completion: nil)
        browser.reloadWithURL(url: URLRequest(url: URL(string: "https://www.theverge.com")!))
    }
}

