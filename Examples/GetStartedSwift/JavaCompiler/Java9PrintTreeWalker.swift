//
//  Java9PrintTreeWalker.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 03/02/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import Foundation
import Antlr4

public class Java9PrintTreeWalker: Java9BaseVisitor<Void> {
    
    override open func visitMethodModifier(_ ctx: Java9Parser.MethodModifierContext) -> Void? {
        print("Method Modifier Declaration: \(ctx.getText())")
        return nil
    }
    
    override open func visitClassBodyDeclaration(_ ctx: Java9Parser.ClassBodyDeclarationContext) -> Void? {
        print("Class Body Declaration:")
        return visitChildren(ctx)
    }
    
    override open func visitClassMemberDeclaration(_ ctx: Java9Parser.ClassMemberDeclarationContext) -> Void? {
        print("Class Member Declaration:")
        return visitChildren(ctx)
    }
    
    override open func visitMethodDeclaration(_ ctx: Java9Parser.MethodDeclarationContext) -> Void? {
        print("Method Declaration:")
        return visitChildren(ctx)
    }
    
    open override func visitChildren(_ node: RuleNode) -> Void? {
        var result = defaultResult()
        let n = node.getChildCount()
        
        for i in 0..<n {
            if !shouldVisitNextChild(node, result) {
                break
            }
            
            let c = node[i]
            let childResult = c.accept(self)
            result = aggregateResult(result, childResult)
        }
        
        return result
    }
    
}
