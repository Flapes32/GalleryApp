import UIKit
import Core
import Models

final class GalleryCell: UICollectionViewCell {
    static let reuseIdentifier = "GalleryCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let favoriteIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "heart.fill")
        iv.tintColor = .systemRed
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubviews(imageView, favoriteIcon)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            favoriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 24),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with photo: UnsplashPhoto, isFavorite: Bool) {
        imageView.setImage(from: photo.urls.small)
        favoriteIcon.isHidden = !isFavorite
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        favoriteIcon.isHidden = true
    }
}
