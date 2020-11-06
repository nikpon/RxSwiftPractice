import UIKit

class MoviesCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = String(describing: MoviesCell.self)
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1.0
        
        return imageView
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 3
        
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.isOpaque = true
        backgroundColor = .systemBackground
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with viewModel: MovieViewModel) {
        viewModel.getImageData(completion: { (imageData) in
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
            }
        }) 
        overviewLabel.text = viewModel.overview
    }
    
}

// MARK: - Setup Views
private extension MoviesCell {
    
    func setupViews() {
        contentView.addSubviews(posterImageView, overviewLabel)
        
        posterImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 10)
        posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        
        overviewLabel.anchor(top: posterImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeading: 15, paddingTrailing: 15)
    }
    
}
