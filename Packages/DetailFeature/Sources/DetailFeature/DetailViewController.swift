import UIKit
import Core
import Combine

public final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 3.0
        return sv
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    public init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        scrollView.delegate = self
        scrollView.addSubview(imageView)

        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            favoriteButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    private func bindViewModel() {
        viewModel.$currentPhoto
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photo in
                self?.updateUI(with: photo)
            }
            .store(in: &cancellables)

        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.updateFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }

    private func updateUI(with photo: UnsplashPhoto) {
        imageView.setImage(from: photo.urls.regular)
        titleLabel.text = photo.user?.name ?? "Unknown"
        descriptionLabel.text = photo.description ?? photo.altDescription ?? "No description"
    }

    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
    }

    @objc private func favoriteButtonTapped() {
        Task {
            await viewModel.toggleFavorite()
        }
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            viewModel.moveToNextPhoto()
        } else if gesture.direction == .right {
            viewModel.moveToPreviousPhoto()
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
