//
//  RightShareFeedCell.swift
//  Yep
//
//  Created by ChaiYixiao on 4/21/16.
//  Copyright © 2016 Catch Inc. All rights reserved.
//

import UIKit
import YepKit
import YepConfig

final class RightShareFeedCell: ChatBaseCell {
    
    var mediaView:FeedMediaView?
    
    lazy var feedKindImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 42, height: 42))
        return imageView
    }()
    
    var topLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        label.text = NSLocalizedString("给你分享一个话题：", comment: "")
        return label
    }()
    
    var accessoryView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_accessory_mini"))

        return imageView
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        label.numberOfLines = 1
        return label
    }()
    
    var conversation: Conversation!
    
    typealias MediaTapAction = () -> Void
    var mediaTapAction: MediaTapAction?
    
    let cellBackgroundImageView: UIImageView = {
        // TODO: WRONG IMAGE
        let imageView = UIImageView(image: UIImage(named: "share_feed_bubble_left"))
        imageView.userInteractionEnabled = true
        return imageView
    }()
    
    lazy var loadingProgressView: MessageLoadingProgressView = {
        let view = MessageLoadingProgressView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.hidden = true
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cellBackgroundImageView)
        contentView.addSubview(loadingProgressView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatLeftImageCell.tapMediaView))
        cellBackgroundImageView.addGestureRecognizer(tap)
        
        UIView.performWithoutAnimation { [weak self] in
            self?.makeUI()
        }
        
        prepareForMenuAction = { otherGesturesEnabled in
            tap.enabled = otherGesturesEnabled
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        mediaView?.clearImages()
        feedKindImageView.image = nil
        topLabel.text = ""
        detailLabel.text = ""
    }
    
    func makeUI() {
        if let feedKindImage = makeFeedKindImage() {
            feedKindImageView.image = feedKindImage
            contentView.addSubview(feedKindImageView)
        }
        
        let avatarRadius = YepConfig.chatCellAvatarSize() / 2
        
        let topOffset: CGFloat = 0
        
        avatarImageView.center = CGPoint(x: YepConfig.chatCellGapBetweenWallAndAvatar() + avatarRadius, y: avatarRadius + topOffset)
    }
    
    private func makeFeedKindImage() -> UIImage? {
        if let feed = conversation.withGroup?.withFeed, let feedKind = FeedKind(rawValue:feed.kind) {
            switch  feedKind {
            case .DribbbleShot:
                return UIImage(named:"icon_dribbble")
            case .GithubRepo:
                return UIImage(named:"icon_github")
            case .Image:
                var discoveredAttachments = [DiscoveredAttachment]()
                feed.attachments.forEach({ (attachment) in
                    let discoveredAttachment = DiscoveredAttachment(metadata: attachment.metadata, URLString: attachment.URLString, image: nil)
                    discoveredAttachments.append(discoveredAttachment)
                })
                
                mediaView?.setImagesWithAttachments(discoveredAttachments)

                if let mediaView = self.mediaView {
                    mediaView.subviews.forEach { (view) in
                        view.userInteractionEnabled = true
                    }
                    mediaView.frame = CGRect(x: 10, y: 10, width: 42, height: 42)
                    contentView.addSubview(mediaView)
                }
                break
            case .Location:
                return UIImage(named:"icon_pin_shadow")
            default :
                return UIImage(named: "icon_topic_text")
            }
        }
       return nil
    }
    
    func configureWithMessage(message: Message, collectionView: UICollectionView, indexPath: NSIndexPath, mediaTapAction: MediaTapAction?) {
        
    }
}
