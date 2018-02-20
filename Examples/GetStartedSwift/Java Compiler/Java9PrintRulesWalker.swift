//
//  Java9PrintRulesWalker.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 20/02/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import Foundation
import Antlr4

class Java9PrintRulesWalker: Java9BaseVisitor<String> {
    
    var parser : Java9Parser? = nil
    
    init(_ parser: Java9Parser) {
        self.parser = parser
    }
    
    open override func visitClassDeclaration(_ ctx: Java9Parser.ClassDeclarationContext) -> String? {
        print("visitClassDeclaration \(ctx.getText())")
        return "visitClassDeclaration \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitClassBodyDeclaration(_ ctx: Java9Parser.ClassBodyDeclarationContext) -> String? {
        print("visitClassBodyDeclaration \(ctx.getText())")
        return "visitClassBodyDeclaration \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitClassMemberDeclaration(_ ctx: Java9Parser.ClassMemberDeclarationContext) -> String? {
        print("visitClassMemberDeclaration \(ctx.getText())")
        return "visitClassMemberDeclaration \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitMethodDeclaration(_ ctx: Java9Parser.MethodDeclarationContext) -> String? {
        print("visitMethodDeclaration \(ctx.getText())")
        let childStr = visitChildren(ctx)
        return "visitMethodDeclaration \n" + "\(childStr ?? "")"
    }
    
    open override func visitMethodHeader(_ ctx: Java9Parser.MethodHeaderContext) -> String? {
        print("visitMethodHeader \(ctx.getText())")
        return "visitMethodHeader \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitMethodBody(_ ctx: Java9Parser.MethodBodyContext) -> String? {
        print("visitMethodBody \(ctx.getText())")
        return "visitMethodBody \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitResult(_ ctx: Java9Parser.ResultContext) -> String? {
        print("visitResult \(ctx.getText())")
        return "visitResult \n" + "\(visitChildren(ctx) ?? "" )"
    }

    open override func visitMethodDeclarator(_ ctx: Java9Parser.MethodDeclaratorContext) -> String? {
        print("visitMethodDeclarator \(ctx.getText())")
        return "visitMethodDeclarator \n" + "\(visitChildren(ctx) ?? "")"
    }
    
    open override func visitFormalParameterList(_ ctx: Java9Parser.FormalParameterListContext) -> String? {
        print("visitFormalParameterList \(ctx.getText())")
        return "visitFormalParameterList \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitLastFormalParameter(_ ctx: Java9Parser.LastFormalParameterContext) -> String? {
        print("visitLastFormalParameter \(ctx.getText())")
        return "visitLastFormalParameter \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitFormalParameter(_ ctx: Java9Parser.FormalParameterContext) -> String? {
        print("visitFormalParameter \(ctx.getText())")
        return "visitFormalParameter \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitVariableDeclaratorId(_ ctx: Java9Parser.VariableDeclaratorIdContext) -> String? {
        print("visitVariableDeclaratorId \(ctx.getText())")
        return "visitVariableDeclaratorId \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnannType(_ ctx: Java9Parser.UnannTypeContext) -> String? {
        print("visitUnannType \(ctx.getText())")
        return "visitUnannType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnannReferenceType(_ ctx: Java9Parser.UnannReferenceTypeContext) -> String? {
        print("visitUnannReferenceType \(ctx.getText())")
        return "visitUnannReferenceType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnannArrayType(_ ctx: Java9Parser.UnannArrayTypeContext) -> String? {
        print("visitUnannArrayType \(ctx.getText())")
        return "visitUnannArrayType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnannPrimitiveType(_ ctx: Java9Parser.UnannPrimitiveTypeContext) -> String? {
        print("visitUnannPrimitiveType \(ctx.getText())")
        return "visitUnannPrimitiveType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitNumericType(_ ctx: Java9Parser.NumericTypeContext) -> String? {
        print("visitNumericType \(ctx.getText())")
        return "visitNumericType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitIntegralType(_ ctx: Java9Parser.IntegralTypeContext) -> String? {
        print("visitIntegralType \(ctx.getText())")
        return "visitIntegralType \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitDims(_ ctx: Java9Parser.DimsContext) -> String? {
        print("visitDims \(ctx.getText())")
        return "visitDims \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitTerminal(_ node: TerminalNode) -> String? {
        let tokenType = parser?.getVocabulary().getSymbolicName(node.getSymbol()?.getType() ?? -1)
        return "Token type: \(tokenType ?? "")" + " " + "\(node.getSymbol()?.getText() ?? "" )" + "\n"
    }
    
    open override func aggregateResult(_ aggregate: String?, _ nextResult: String?) -> String? {
        return "\(aggregate ?? "" )" +  "\(nextResult ?? "" )" 
    }
    
    var visitChildrenCount = 0;
    
    open override func visitChildren(_ node: RuleNode) -> String? {
        var result: String? = defaultResult()
        visitChildrenCount += 1
        let n = node.getChildCount()
        
        for i in 0..<n {
            if !shouldVisitNextChild(node, result) {
                break
            }
            
            var tabs = ""
            for _ in 0..<visitChildrenCount {
                tabs += "\t"
            }
            
            let c = node[i]
            let childResult = c.accept(self)
            result = aggregateResult("\(result ?? "")" + tabs, childResult)
            
        }
        visitChildrenCount -= 1
        return result
    }
}
