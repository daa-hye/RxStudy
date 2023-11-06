//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 박다혜 on 11/6/23.
//

import UIKit
import RxCocoa
import RxSwift

class ShoppingListViewController: UIViewController {

    let disposeBag = DisposeBag()

    private let tableView: UITableView = {
       let view = UITableView()
        view.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
       return view
     }()

    let searchBar = UISearchBar()

    var data: [Stuff] = []
    lazy var items = BehaviorSubject(value: data)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configure()
        bind()
        setSearchController()
    }

    private func bind() {

        items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.checkImageView.rx.image
                    .onNext(element.done ? UIImage(systemName: "checkmark.diamond.fill"): UIImage(systemName: "checkmark.diamond"))
                cell.likeButton.rx.image(for: .normal)
                    .onNext(element.like ? UIImage(systemName: "heart.fill"): UIImage(systemName: "heart"))

                cell.likeButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.data[row].like.toggle()
                        owner.items.onNext(owner.data)
                    }
                    .disposed(by: cell.disposeBag)

            }
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) { _, text in
                return text
            }
            .subscribe(with: self) { owner, text in
                owner.data.insert(Stuff(title: text), at: 0)
                owner.items.onNext(owner.data)
            }
            .disposed(by: disposeBag)
    }

    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
