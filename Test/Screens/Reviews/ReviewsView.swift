import UIKit

protocol ReviewsViewDelegate: AnyObject {
    func didUseRefreshControl()
}

final class ReviewsView: UIView {
    
    private let refreshControl = UIRefreshControl()
    private let footerLabel = UILabel()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .label
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
        return tableView
    }()
    
    weak var delegate: ReviewsViewDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: safeAreaInsets)
    }
}

// MARK: - Internal Methods

extension ReviewsView {
    
    func updateCountOfReviews(_ count: Int) {
        footerLabel.text = "\(count) отзывов"
    }
    
    func setLoading(_ isLoading: Bool) {
        isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
}

// MARK: - Private Setup Methods

private extension ReviewsView {
    
    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
        setupFooterLabel()
        setupRefreshControl()
        setupActivityIndicatorView()
        setupConstraints()
    }
    
    func setupTableView() {
        addSubview(tableView)
    }
    
    func setupFooterLabel() {
        footerLabel.textAlignment = .center
        footerLabel.font = .reviewCount
        footerLabel.textColor = .reviewCount
        footerLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        tableView.tableFooterView = footerLabel
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setupActivityIndicatorView() {
        addSubview(activityIndicatorView)
    }
}

// MARK: - Layout Constraints

private extension ReviewsView {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Actions

private extension ReviewsView {
    
    @objc
    func refreshData() {
        delegate?.didUseRefreshControl()
        refreshControl.endRefreshing()
    }
}
