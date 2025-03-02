import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        fetchData()
    }
}

// MARK: - Private Methods

private extension ReviewsViewController {
    
    func setupBindings() {
        setupViewModelBindings()
    }
    
    func fetchData() {
        viewModel.getReviews()
        RatingRenderer.shared.preloadCache()
    }

    func setupViewModelBindings() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.reviewsView.tableView.reloadData()
                self.reviewsView.updateCountOfReviews(state.items.count)
                self.reviewsView.setLoading(state.isLoading)
            }
        }
    }
    
   
    
    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        reviewsView.delegate = self
        return reviewsView
    }
}

// MARK: - ReviewsViewDelegate

extension ReviewsViewController: ReviewsViewDelegate {
    
    func didUseRefreshControl() {
        viewModel.getReviews()
    }
}
