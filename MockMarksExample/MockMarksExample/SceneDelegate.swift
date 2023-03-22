import MockMarks
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(windowScene: windowScene)

    // 1. Do MockMarks's global setup, passing in our session.
    MockMarks.shared.setUp(session: MockMarks.Session(mocking: .shared))

    // 2. Use the MockMarks session if it's available in your app.
    let vm = ViewModel(urlSession: MockMarks.shared.session as? URLSession ?? .shared)

    // 3. Let's get going!
    self.window?.rootViewController = ViewController(viewModel: vm)
    self.window?.makeKeyAndVisible()
  }
}
