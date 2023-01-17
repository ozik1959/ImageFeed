import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewIdentifier = "ShowWebView"
    
    weak var oAuth2Service: OAuth2Service?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to pdrepare for \(showWebViewIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        DispatchQueue.main.async {
            
            self.oAuth2Service?.fetchOAuthToken(code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    
                case .success(let token):
                    OAuth2TokenStorage().token = token
                    print("ok")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
            dismiss(animated: true)
        }
    }

