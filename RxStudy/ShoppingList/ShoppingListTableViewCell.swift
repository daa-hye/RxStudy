//
//  ShoppingListTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 박다혜 on 11/6/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListTableViewCell: UITableViewCell {

    static let identifier = "ShoppingListTableViewCell"

    var disposeBag = DisposeBag()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.diamond")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.isUserInteractionEnabled = true
        button.tintColor = .systemPink
        button.backgroundColor = .clear
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkImageView)
        contentView.addSubview(likeButton)

        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkImageView)
            $0.leading.equalTo(checkImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(likeButton.snp.leading).offset(-8)
        }

        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(checkImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
    }

}
