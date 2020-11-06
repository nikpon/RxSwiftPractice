import UIKit

fileprivate var loaderView: UIView!

public extension UIViewController {
    
    func showSpinner() {
        loaderView = UIView(frame: view.bounds)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderView)
        loaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        loaderView.backgroundColor = .secondarySystemBackground
        loaderView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            loaderView.alpha = 0.6
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderView.center
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor).isActive = true
    }
    
    func removeSpinner() {
        guard loaderView != nil else { return }
        loaderView.removeFromSuperview()
        loaderView = nil
    }
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        var topViewController = self
        topViewController.modalPresentationStyle = .fullScreen
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        topViewController.present(viewController, animated: animated)
    }
    
}
