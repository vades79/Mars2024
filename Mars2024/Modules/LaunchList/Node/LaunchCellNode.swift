//
//  LaunchCellNode.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class LaunchCellNode: ASCellNode {
    
    var imageNode: ASNetworkImageNode!
    var descriptionNode: TitleAndSubtitleDisplayNode!
    
    init(launch: Launch) {
        super.init()
        
        backgroundColor = .white
        self.automaticallyManagesSubnodes = true
        
        imageNode = ASNetworkImageNode()
        imageNode.url = launch.missionPatchSmall
        imageNode.backgroundColor = .white
        
        let title = launch.missionName
        let attributedTitle = title.attributedString(.title2())
        
        var subtitle = ""
        if launch.details.isEmpty {
            subtitle = R.string.localizable.launchDetailsEmptyDescription()
        } else {
            subtitle = launch.details
        }
        let attributedSubtitle = subtitle.attributedString(.title3())
        
        descriptionNode = TitleAndSubtitleDisplayNode(title: attributedTitle, subtitle: attributedSubtitle)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let imageNodeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        let imageNodeInsetsSpec = ASInsetLayoutSpec(insets: imageNodeInsets, child: imageNode)
        imageNode.style.preferredSize = CGSize(width: 100.scaled, height: 100.scaled)
        
        let textContainerInset = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        let textContainerSpec = ASInsetLayoutSpec(insets: textContainerInset, child: descriptionNode)
        
        let horStack = ASStackLayoutSpec.horizontal()
        horStack.alignItems = .start
        horStack.children = [imageNodeInsetsSpec, textContainerSpec]
        
        return horStack
    }
}
