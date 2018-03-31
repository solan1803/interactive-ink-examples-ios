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
    
    open override func visitBlock(_ ctx: Java9Parser.BlockContext) -> String? {
        print("visitBlock \(ctx.getText())")
        return "visitBlock \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitBlockStatements(_ ctx: Java9Parser.BlockStatementsContext) -> String? {
        print("visitBlockStatements \(ctx.getText())")
        return "visitBlockStatements \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitBlockStatement(_ ctx: Java9Parser.BlockStatementContext) -> String? {
        print("visitBlockStatement \(ctx.getText())")
        return "visitBlockStatement \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitStatement(_ ctx: Java9Parser.StatementContext) -> String? {
        print("visitStatement \(ctx.getText())")
        return "visitStatement \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitForStatement(_ ctx: Java9Parser.ForStatementContext) -> String? {
        print("visitForStatement \(ctx.getText())")
        return "visitForStatement \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitLocalVariableDeclarationStatement(_ ctx: Java9Parser.LocalVariableDeclarationStatementContext) -> String? {
        print("visitLocalVariableDeclarationStatement \(ctx.getText())")
        return "visitLocalVariableDeclarationStatement \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitLocalVariableDeclaration(_ ctx: Java9Parser.LocalVariableDeclarationContext) -> String? {
        print("visitLocalVariableDeclaration \(ctx.getText())")
        return "visitLocalVariableDeclaration \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitVariableDeclaratorList(_ ctx: Java9Parser.VariableDeclaratorListContext) -> String? {
        print("visitVariableDeclaratorList \(ctx.getText())")
        return "visitVariableDeclaratorList \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitVariableDeclarator(_ ctx: Java9Parser.VariableDeclaratorContext) -> String? {
        print("visitVariableDeclarator \(ctx.getText())")
        return "visitVariableDeclarator \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitVariableInitializer(_ ctx: Java9Parser.VariableInitializerContext) -> String? {
        print("visitVariableInitializer \(ctx.getText())")
        return "visitVariableInitializer \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitExpression(_ ctx: Java9Parser.ExpressionContext) -> String? {
        print("visitExpression \(ctx.getText())")
        return "visitExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitAssignmentExpression(_ ctx: Java9Parser.AssignmentExpressionContext) -> String? {
        print("visitAssignmentExpression \(ctx.getText())")
        return "visitAssignmentExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitConditionalExpression(_ ctx: Java9Parser.ConditionalExpressionContext) -> String? {
        print("visitConditionalExpression \(ctx.getText())")
        return "visitConditionalExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitConditionalOrExpression(_ ctx: Java9Parser.ConditionalOrExpressionContext) -> String? {
        print("visitConditionalOrExpression \(ctx.getText())")
        return "visitConditionalOrExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitConditionalAndExpression(_ ctx: Java9Parser.ConditionalAndExpressionContext) -> String? {
        print("visitConditionalAndExpression \(ctx.getText())")
        return "visitConditionalAndExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitInclusiveOrExpression(_ ctx: Java9Parser.InclusiveOrExpressionContext) -> String? {
        print("visitInclusiveOrExpression \(ctx.getText())")
        return "visitInclusiveOrExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitExclusiveOrExpression(_ ctx: Java9Parser.ExclusiveOrExpressionContext) -> String? {
        print("visitExclusiveOrExpression \(ctx.getText())")
        return "visitExclusiveOrExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitAndExpression(_ ctx: Java9Parser.AndExpressionContext) -> String? {
        print("visitAndExpression \(ctx.getText())")
        return "visitAndExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitEqualityExpression(_ ctx: Java9Parser.EqualityExpressionContext) -> String? {
        print("visitEqualityExpression \(ctx.getText())")
        return "visitEqualityExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitRelationalExpression(_ ctx: Java9Parser.RelationalExpressionContext) -> String? {
        print("visitRelationalExpression \(ctx.getText())")
        return "visitRelationalExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitShiftExpression(_ ctx: Java9Parser.ShiftExpressionContext) -> String? {
        print("visitShiftExpression \(ctx.getText())")
        return "visitShiftExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitAdditiveExpression(_ ctx: Java9Parser.AdditiveExpressionContext) -> String? {
        print("visitAdditiveExpression \(ctx.getText())")
        return "visitAdditiveExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitMultiplicativeExpression(_ ctx: Java9Parser.MultiplicativeExpressionContext) -> String? {
        print("visitMultiplicativeExpression \(ctx.getText())")
        return "visitMultiplicativeExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnaryExpression(_ ctx: Java9Parser.UnaryExpressionContext) -> String? {
        print("visitUnaryExpression \(ctx.getText())")
        return "visitUnaryExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitUnaryExpressionNotPlusMinus(_ ctx: Java9Parser.UnaryExpressionNotPlusMinusContext) -> String? {
        print("visitUnaryExpressionNotPlusMinus \(ctx.getText())")
        return "visitUnaryExpressionNotPlusMinus \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitPostfixExpression(_ ctx: Java9Parser.PostfixExpressionContext) -> String? {
        print("visitPostfixExpression \(ctx.getText())")
        return "visitPostfixExpression \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitPrimary(_ ctx: Java9Parser.PrimaryContext) -> String? {
        print("visitPrimary \(ctx.getText())")
        return "visitPrimary \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitPrimaryNoNewArray_lfno_primary(_ ctx: Java9Parser.PrimaryNoNewArray_lfno_primaryContext) -> String? {
        print("visitPrimaryNoNewArray_lfno_primary \(ctx.getText())")
        return "visitPrimaryNoNewArray_lfno_primary \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitLiteral(_ ctx: Java9Parser.LiteralContext) -> String? {
        print("visitLiteral \(ctx.getText())")
        return "visitLiteral \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitExpressionName(_ ctx: Java9Parser.ExpressionNameContext) -> String? {
        print("visitExpressionName \(ctx.getText())")
        return "visitExpressionName \n" + "\(visitChildren(ctx) ?? "" )"
    }
    
    open override func visitAmbiguousName(_ ctx: Java9Parser.AmbiguousNameContext) -> String? {
        print("visitAmbiguousName \(ctx.getText())")
        return "visitAmbiguousName \n" + "\(visitChildren(ctx) ?? "" )"
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
                tabs += "    "
            }
            
            let c = node[i]
            let childResult = c.accept(self)
            result = aggregateResult("\(result ?? "")" + tabs, childResult)
            
        }
        visitChildrenCount -= 1
        return result
    }
}
