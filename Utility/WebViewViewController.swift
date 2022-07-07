//
//  WebViewViewController.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
   private var photoLink: String?
    
    init(photoLink: String?) {
        self.photoLink = photoLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        webView.load(URLRequest(url: URL(string: photoLink ?? "") ?? URL(fileURLWithPath: "")))
    }
    
    private func setupView() {
        [webView, activityIndicator].forEach { subView in
            view.addSubview(subView)
        }
        activityIndicator.startAnimating()
        setupConstraints()
        view.backgroundColor = .white
        activityIndicator.frame = self.view.bounds
        webView.navigationDelegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
