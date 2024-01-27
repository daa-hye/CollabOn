//
//  WorkspaceListTableViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class WorkspaceListTableViewCell: UITableViewCell {

    private let backView = UIView()
    private let thumbnailImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let createdDateLabel = UILabel()
    private let settingButton = UIButton()

    weak var delegate: WorkspaceListTableViewCellDelegate?

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configHierarchy()
        setLayout()
        setUIProperties()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backView.backgroundColor = selected ? .coGray : .clear
        settingButton.isHidden = selected ? false : true
    }

    func bindRx() {
        settingButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.delegate?.settingButtonDidTap()
            }
            .disposed(by: disposeBag)
    }

    func configHierarchy() {
        contentView.addSubview(backView)
        backView.addSubview(thumbnailImageView)
        backView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(createdDateLabel)
        backView.addSubview(settingButton)
    }

    func setLayout() {
        backView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(2)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(192)
            $0.height.equalTo(36)
        }

        settingButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }

    func setUIProperties() {
        backView.layer.cornerRadius = 8

        thumbnailImageView.image = .dummy
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true

        titleLabel.font = .bodyBold

        createdDateLabel.font = .body
        createdDateLabel.textColor = .textSecondary

        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.distribution = .fillEqually

        settingButton.setImage(.dots, for: .normal)
        settingButton.isHidden = true
    }

    func setData(_ data: WorkspaceResponse) {
        thumbnailImageView.kf.setImage(with: data.thumbnail, options: [.requestModifier(ImageService.shared.getImage())])
        titleLabel.text = data.name
        createdDateLabel.text = data.createdAt.dateFormat()
    }

}

protocol WorkspaceListTableViewCellDelegate: AnyObject {
    func settingButtonDidTap()
}
