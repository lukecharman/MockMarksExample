import UIKit

class ViewController: UIViewController {

  private let viewModel: ViewModel

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    view.backgroundColor = .white
    view.addSubview(label)
    view.addSubview(loadWordButton)
    view.addSubview(loadLanguageButton)

    NSLayoutConstraint.activate([
      loadWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadWordButton.bottomAnchor.constraint(equalTo: loadLanguageButton.topAnchor),
      loadWordButton.heightAnchor.constraint(equalToConstant: 64),
      loadLanguageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadLanguageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadLanguageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      loadLanguageButton.heightAnchor.constraint(equalToConstant: 64),
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      label.bottomAnchor.constraint(equalTo: loadWordButton.topAnchor)
    ])

    fetchRandomWord()
  }

  private lazy var label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var loadWordButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Load Word", for: .normal)
    button.addTarget(self, action: #selector(fetchRandomWord), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.accessibilityIdentifier = "Load_Word_Button"
    return button
  }()

  private lazy var loadLanguageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Load Language Count", for: .normal)
    button.addTarget(self, action: #selector(fetchLanguageCount), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.accessibilityIdentifier = "Load_Language_Button"
    return button
  }()

  @objc private func fetchRandomWord() {
    viewModel.fetchRandomWord { [weak label] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let string):
          label?.text = string
        case .failure(let error):
          label?.text = error.localizedDescription
        }
      }
    }
  }

  @objc private func fetchLanguageCount() {
    viewModel.fetchLanguageCount { [weak label] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let string):
          label?.text = String(string)
        case .failure(let error):
          label?.text = error.localizedDescription
        }
      }
    }
  }
}
