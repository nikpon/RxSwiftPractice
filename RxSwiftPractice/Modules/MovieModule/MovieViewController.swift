import UIKit

final class MovieViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1.0
        
        return imageView
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .systemBackground
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 18)
        textView.isSelectable = true
        textView.textAlignment = .center
        textView.textColor = .label
        
        return textView
    }()
    
    var viewModel: MovieViewModel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        configureNavigationBar()
        configureViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.dismissed.onNext(Void())
    }
    
    // MARK: - Methods
    private func configureViews() {
        viewModel.getImageData(completion: { (imageData) in
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
            }
        })
        contentTextView.text = viewModel.overview
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
}

// MARK: - Setup Views
private extension MovieViewController {
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        containerView.addSubviews(posterImageView, contentTextView)
        
        posterImageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, paddingTop: 10, paddingLeading: 6, paddingTrailing: 6, height: 200)
        
        contentTextView.anchor(top: posterImageView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, paddingTop: 6, paddingLeading: 6, paddingTrailing: 6)
    }
    
}
