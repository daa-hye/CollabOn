//
//  HomeCollectoinViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 1/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class HomeCollectoinViewCell: UICollectionViewListCell {

    private let baseView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configHierarchy()
        setUI()
        setUIProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: FooterClickDelegate? = nil

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configHierarchy() {
        contentView.addSubview(baseView)
        baseView.addSubview(imageView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(badgeLabel)
    }

    func setUI() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setUIProperties() {
        baseView.backgroundColor = .clear
        titleLabel.font = .body
        badgeLabel.backgroundColor = .main
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.textColor = .white
        badgeLabel.font = .body
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true
    }

    func setData(channel: ChannelResponse) {
        titleLabel.text = channel.name
        imageView.image = .hashtag

        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }

    func setData(dms: DmsResponse) {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(11)
            $0.centerY.equalToSuperview()
        }
    }

    func setHeader(_ section: Int) {
        imageView.isHidden = true
        titleLabel.font = .title2

        if section == 0 {
            titleLabel.text = String(localized: "채널")
        } else if section == 1 {
            titleLabel.text = String(localized: "다이렉트 메시지")
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }

    func setFooter(_ section: Int) {

        if section == 0 {
            titleLabel.text = String(localized: "채널 추가")
            baseView.rx.tapGesture()
                .when(.recognized)
                .bind(with: self) { owner, _ in
                    owner.delegate?.addChannel()
                }
                .disposed(by: disposeBag)
        } else if section == 1 {
            titleLabel.text = String(localized: "새 메시지 시작")
            baseView.rx.tapGesture()
                .when(.recognized)
                .bind(with: self) { owner, _ in
                    owner.delegate?.addMessage()
                }
                .disposed(by: disposeBag)
        } else if section == 2 {
            titleLabel.text = String(localized: "팀원 추가")
            baseView.rx.tapGesture()
                .when(.recognized)
                .bind(with: self) { owner, _ in
                    owner.delegate?.addMember()
                }
                .disposed(by: disposeBag)
        }

        imageView.image = .plus
        titleLabel.textColor = .secondaryLabel

        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
    }

}
