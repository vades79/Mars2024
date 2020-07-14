//
//  TitleAndSubtitleDisplayNode.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class TitleAndSubtitleDisplayNode: ASDisplayNode {
    
    var titleNode: ASTextNode!
    var subtitleNode: ASTextNode!
    
    var titleInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    var subtitleInsets = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    
    var size = CGSize(width: 250.scaled, height: 60.vscaled)
    
    init(title: NSAttributedString?, subtitle: NSAttributedString?) {
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        titleNode = ASTextNode()
        titleNode.attributedText = title
        
        subtitleNode = ASTextNode()
        subtitleNode.attributedText = subtitle
        subtitleNode.maximumNumberOfLines = 3
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let titleInsetsSpec = ASInsetLayoutSpec(insets: titleInsets, child: titleNode)
        let subtitleInsetsSpec = ASInsetLayoutSpec(insets: subtitleInsets, child: subtitleNode)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 8
        stack.alignItems = .start
        stack.children = [titleInsetsSpec, subtitleInsetsSpec]
        
        stack.style.maxSize = size
        
        return stack
    }    
}
