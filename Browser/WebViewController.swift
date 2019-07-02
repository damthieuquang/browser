//
//  WebViewController.swift
//  kidfitness
//
//  Created by Dam Thieu Quang on 5/29/19.
//  Copyright © 2019 Dam Thieu Quang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var titlePage: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var contentAddressView: UIView!
    var webView : WKWebView?
    let cornerRadius = 4.0
    var progressBar : ProgressBarView?
    var temp : NSLayoutConstraint?
    var currentProgress : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    deinit {
        print("\(self) has been released...")
        NotificationCenter.default.removeObserver(self)

    }

    // MARK: setup
    func setup() {
        // set up layout title page view
        self.titleView.backgroundColor = .clear
        self.contentAddressView.backgroundColor = UIColor(red: 3/255, green: 3/255, blue: 3/255, alpha: 0.1)
        self.contentAddressView.clipsToBounds = true
        self.contentAddressView.layer.cornerRadius = CGFloat(cornerRadius)
        
        self.titlePage.delegate = self
        self.titlePage.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        self.titlePage.leftViewMode = .always
        self.titlePage.isUserInteractionEnabled = false
        self.titlePage.textAlignment = .center
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        self.webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        self.webView!.navigationDelegate = self
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: [.new, .initial], context: nil)
        self.contentView.addSubview(self.webView!)
        
        self.webView?.translatesAutoresizingMaskIntoConstraints = false
        self.webView?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.webView?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.webView?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.webView?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        self.progressBar = ProgressBarView(frame: .zero)
        self.progressBar?.setProgress(ratio: 0)
        self.contentView?.addSubview(progressBar!)
        self.progressBar?.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.progressBar?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.temp = self.progressBar?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        self.temp?.isActive = true
        self.progressBar?.backgroundColor  = .red
        
        self.progressBar?.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    @objc func rotated() {
        self.progressBar?.setProgress(ratio: self.currentProgress)
    }
    
    func reloadWithURL(url: URLRequest) {
        webView?.load(url)
    }
    
    // MARK: action
    @IBAction func previousAction(_ sender: Any) {
        if self.webView!.canGoBack {
            self.webView?.goBack()
        }
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        if self.webView!.canGoForward {
            self.webView?.goForward()
        }
    }
    
    @IBAction func optionalAction(_ sender: Any) {
        let alertVC = UIAlertController(title: "Thông báo", message: "Sao chép liên kết", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Sao chép", style: .default) { (alert) in
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = self.webView?.url?.absoluteString
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        if self.webView!.url!.absoluteString.count > 0 {
            self.webView?.reload()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("estimatedProgress:\(self.webView?.estimatedProgress ?? 0)")
            self.currentProgress = CGFloat(self.webView!.estimatedProgress)
            self.progressBar?.setProgress(ratio: CGFloat(self.webView!.estimatedProgress))
        }
    }
}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let title = webView.title {
            self.titlePage.text = title
        }
        self.previous.isEnabled = self.webView!.canGoBack
        self.forward.isEnabled = self.webView!.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let title = webView.title {
            self.titlePage.text = title
        }
        self.previous.isEnabled = self.webView!.canGoBack
        self.forward.isEnabled = self.webView!.canGoForward
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

extension WebViewController : UITextFieldDelegate {
    
}
