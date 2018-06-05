//
//  Java9ANTLRSemanticFixesWalker.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 03/06/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import Foundation
import Antlr4

class Java9ANTLRSemanticFixesWalker: Java9BaseVisitor<Void> {
    
    var parser : Java9Parser? = nil
    var flattenedWordsList: [Word]
    var startingLineOfCodeBody: Int
    var startingLineOfClosingCode: Int
    var indexInCurrentWord = 0
    var wordIndex = 0
    var currentWord: Word
    var symbolTable: SymbolTable
    
    init(_ parser: Java9Parser, flattenedWordsList: [Word], startingLineOfCodeBody: Int, startingLineOfClosingCode: Int) {
        self.parser = parser
        self.flattenedWordsList = flattenedWordsList
        self.startingLineOfCodeBody = startingLineOfCodeBody
        self.startingLineOfClosingCode = startingLineOfClosingCode
        currentWord = flattenedWordsList[wordIndex]
        symbolTable = SymbolTable()
        symbolTable.addIdentifier(name: "void", identifier: Type())
        symbolTable.addIdentifier(name: "byte", identifier: Type())
        symbolTable.addIdentifier(name: "short", identifier: Type())
        symbolTable.addIdentifier(name: "int", identifier: Type())
        symbolTable.addIdentifier(name: "long", identifier: Type())
        symbolTable.addIdentifier(name: "float", identifier: Type())
        symbolTable.addIdentifier(name: "double", identifier: Type())
        symbolTable.addIdentifier(name: "char", identifier: Type())
        symbolTable.addIdentifier(name: "boolean", identifier: Type())
        symbolTable.addIdentifier(name: "String", identifier: Type())
        symbolTable.addIdentifier(name: "ListNode", identifier: Type())
    }
    
    open override func visitClassBody(_ ctx: Java9Parser.ClassBodyContext) {
        print("visitClassbody")
        visitChildren(ctx)
    }
    
    open override func visitMethodDeclaration(_ ctx: Java9Parser.MethodDeclarationContext) {
        print("visitMethodDeclaration")
        visitChildren(ctx)
    }
    
    open override func visitMethodBody(_ ctx: Java9Parser.MethodBodyContext) {
        print("visitMethodBody \(ctx.getText())")
        visitChildren(ctx)
    }
    
    open override func visitFormalParameter(_ ctx: Java9Parser.FormalParameterContext) {
        let type = symbolTable.lookUpAll(name: (ctx.unannType()?.getText())!) as! Type
        let varId = ctx.variableDeclaratorId()?.getText()
        symbolTable.addIdentifier(name: varId!, identifier: Variable(type: type))
        visitChildren(ctx)
    }
    
    open override func visitTerminal(_ node: TerminalNode) {
        if (node.getSymbol()?.getLine())! >= startingLineOfCodeBody && (node.getSymbol()?.getLine())! < startingLineOfClosingCode {
            print(node.getText())
            if node.getText().count >= currentWord.label.count - indexInCurrentWord {
                // overflows onto next bounding box
                var indexInToken = 0
                while node.getText().count - indexInToken >= currentWord.label.count - indexInCurrentWord  {
                    indexInToken = currentWord.label.count - indexInCurrentWord + indexInToken
                    // move to next Word object
                    indexInCurrentWord = 0
                    wordIndex = wordIndex + 1
                    currentWord = flattenedWordsList[wordIndex]
                }
                // complete partial overflow in current word
                indexInCurrentWord = indexInCurrentWord + node.getText().count - indexInToken
            } else {
                indexInCurrentWord = indexInCurrentWord + node.getText().count
            }
        }
    }
    
    open override func visitLocalVariableDeclaration(_ ctx: Java9Parser.LocalVariableDeclarationContext) {
        let unannType = ctx.unannType()
        let type = symbolTable.lookUpAll(name: checkAndFixType(unannType: unannType!))
        if let variablesList = ctx.variableDeclaratorList()?.children {
            for vDecOrComma in variablesList {
                if let v = vDecOrComma as? Java9Parser.VariableDeclaratorContext {
                    let id = v.variableDeclaratorId()?.getText()
                    symbolTable.addIdentifier(name: id!, identifier: type!)
                    visit(v.variableDeclaratorId()!)
                    if let variableInitialiser = v.variableInitializer() {
                        visitTerminal((v.getChild(1) as? TerminalNode)!) // visit equals
                        if let expression = variableInitialiser.expression() {
                            if let assignmentExpression = expression.assignmentExpression() {
                                if let conditionalExpression = assignmentExpression.conditionalExpression(), let conditionalOrExpression = conditionalExpression.conditionalOrExpression(),
                                    let conditionalAndExpression = conditionalOrExpression.conditionalAndExpression(),
                                    let inclusiveOrExpression = conditionalAndExpression.inclusiveOrExpression(), let exclusiveOrExpression = inclusiveOrExpression.exclusiveOrExpression(),
                                    let andExpression = exclusiveOrExpression.andExpression(), let equalityExpression = andExpression.equalityExpression(),
                                    let relationalExpression = equalityExpression.relationalExpression(), let shiftExpression = relationalExpression.shiftExpression(),
                                    let additiveExpression = shiftExpression.additiveExpression(), let multiplicativeExpression = additiveExpression.multiplicativeExpression(),
                                    let unaryExpression = multiplicativeExpression.unaryExpression(), let unaryExpressionNotPlusMinus = unaryExpression.unaryExpressionNotPlusMinus(),
                                    let postFixExpression = unaryExpressionNotPlusMinus.postfixExpression(), let expressionName = postFixExpression.expressionName(),
                                    let identifier = expressionName.Identifier() {
                                    // note: this will create a missing variable in symbol table if levenshtein does not match.
                                    checkAndFixIdentifier(identifier: identifier.getText(), ctx: assignmentExpression, identifierClass: Variable(type: type as! Type))
                                } else {
                                    visitChildren(assignmentExpression)
                                }
                            } else {
                                visitChildren(expression)
                            }
                        }
                    }
                } else {
                    visitTerminal((vDecOrComma as? TerminalNode)!)
                }
            }
        }
    }
    
    open override func visitUnannClassType_lfno_unannClassOrInterfaceType(_ ctx: Java9Parser.UnannClassType_lfno_unannClassOrInterfaceTypeContext) {
        print(ctx.getText())
        visitChildren(ctx)
    }
    
    func checkAndFixType(unannType:  Java9Parser.UnannTypeContext)->String {
        if let primType = unannType.unannPrimitiveType() {
            visitChildren(primType)
        } else if let refType = unannType.unannReferenceType() {
            if let unannTypeVar = refType.unannTypeVariable() {
                // New type e.g. NodeList, so we need to see if similar types exist, and replace or add new type
                let identifier = unannType.getText()
                return checkAndFixIdentifier(identifier: identifier, ctx: unannTypeVar, identifierClass: Type())
            } else if let unannClassOrInterfaceType = refType.unannClassOrInterfaceType() {
                if let unannClassType_lfno = unannClassOrInterfaceType.unannClassType_lfno_unannClassOrInterfaceType() {
                    let identifier = unannClassType_lfno.Identifier()?.getText()
                    return checkAndFixIdentifier(identifier: identifier!, ctx: unannClassType_lfno, identifierClass: Type())
                } else {
                    print("Not handling case unannClassOrInterfaceType")
                }
            } else if let unannArrayType = refType.unannArrayType() {
                visitChildren(unannArrayType)
            }
        }
        return unannType.getText()
    }
    
    func checkAndFixIdentifier(identifier: String, ctx: ParserRuleContext, identifierClass: Identifier)->String {
        if let _ = symbolTable.lookUpAll(name: identifier) {
            visitChildren(ctx)
        } else if let foundCloseIdentifier = symbolTable.lookUpAllWithLevenshteinDistance(name: identifier, identifier: identifierClass) {
            if currentWord.label.count - indexInCurrentWord >= foundCloseIdentifier.count {
                let startIndex = currentWord.label.index(currentWord.label.startIndex, offsetBy: indexInCurrentWord)
                let endIndex = currentWord.label.index(currentWord.label.startIndex, offsetBy: indexInCurrentWord + foundCloseIdentifier.count)
                currentWord.fixProviders.append(.ANTLRFix(currentWord.label))
                currentWord.label = currentWord.label.replacingCharacters(in: startIndex..<endIndex, with: foundCloseIdentifier)
            } else {
                // overflows onto next bounding box
                var indexInCloseIdentifierString = 0
                while foundCloseIdentifier.count - indexInCloseIdentifierString >= currentWord.label.count - indexInCurrentWord  {
                    // if there is a difference, then update label and add fix provider, else move on
                    let sIndexInWord = currentWord.label.index(currentWord.label.startIndex, offsetBy: indexInCurrentWord)
                    let eIndexInWord = currentWord.label.endIndex
                    let sIndexInCloseIdentifier = foundCloseIdentifier.index(foundCloseIdentifier.startIndex, offsetBy: indexInCloseIdentifierString)
                    let eIndexInCloseIdentifier = foundCloseIdentifier.index(sIndexInCloseIdentifier, offsetBy: currentWord.label.count - indexInCurrentWord)
                    assert(currentWord.label[sIndexInWord..<eIndexInWord].count == foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier].count)
                    if currentWord.label[sIndexInWord..<eIndexInWord] != foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier] {
                        currentWord.fixProviders.append(.ANTLRFix(currentWord.label))
                        currentWord.label.replaceSubrange(sIndexInWord..<eIndexInWord, with: foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier])
                    }
                    indexInCloseIdentifierString = currentWord.label.count - indexInCurrentWord + indexInCloseIdentifierString
                    // move to next Word object
                    indexInCurrentWord = 0
                    wordIndex = wordIndex + 1
                    currentWord = flattenedWordsList[wordIndex]
                }
                // complete partial overflow in current word
                let sIndexInWord = currentWord.label.index(currentWord.label.startIndex, offsetBy: indexInCurrentWord)
                let eIndexInWord = currentWord.label.index(sIndexInWord, offsetBy: foundCloseIdentifier.count - indexInCloseIdentifierString)
                let sIndexInCloseIdentifier = foundCloseIdentifier.index(foundCloseIdentifier.startIndex, offsetBy: indexInCloseIdentifierString)
                let eIndexInCloseIdentifier = foundCloseIdentifier.endIndex
                assert(currentWord.label[sIndexInWord..<eIndexInWord].count == foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier].count)
                if currentWord.label[sIndexInWord..<eIndexInWord] != foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier] {
                    currentWord.fixProviders.append(.ANTLRFix(currentWord.label))
                    currentWord.label.replaceSubrange(sIndexInWord..<eIndexInWord, with: foundCloseIdentifier[sIndexInCloseIdentifier..<eIndexInCloseIdentifier])
                }
                indexInCurrentWord = indexInCurrentWord + foundCloseIdentifier.count - indexInCloseIdentifierString
            }
            return foundCloseIdentifier
        } else {
            // lookUpAllWithLevenshteinDistance created new type entry, so can visitChildren normally
            visitChildren(ctx)
        }
        return ctx.getText()
    }
    
}

public class SymbolTable {
    
    var parent: SymbolTable? = nil
    var dictionary: Dictionary<String, Identifier> = [:]
    
    init() {}
    
    init(st: SymbolTable) {
        parent = st
    }
    
    func addIdentifier(name: String, identifier: Identifier) {
        dictionary[name] = identifier
    }
    
    func lookUpAll(name: String) -> Identifier? {
        var currSt: SymbolTable? = self
        while (currSt != nil) {
            if let identifier = currSt!.dictionary[name] {
                return identifier
            } else {
                currSt = currSt!.parent
            }
        }
        return nil
    }
    
    func lookUpAllWithLevenshteinDistance(name: String, identifier: Identifier) -> String? {
        var currSt: SymbolTable? = self
        let THRESHOLD_SCORE: Float = 0.7
        var bestScore: Float = 0.0
        var bestMatch = ""
        while (currSt != nil) {
            for k in currSt!.dictionary.keys {
                if k.count == name.count {
                    let lScore = name.levenshteinDistanceScoreTo(string: k)
                    if bestScore < lScore {
                        bestScore = lScore
                        bestMatch = k
                    }
                }
            }
            currSt = currSt!.parent
        }
        if bestScore > THRESHOLD_SCORE {
            return bestMatch
        }
        // Add new entry
        dictionary[name] = identifier
        return nil
    }
    
}

public class Identifier {
    
}

public class Type: Identifier {
    
}

public class Variable: Identifier {
    var type: Type
    
    init(type: Type) {
        self.type = type
    }
}

extension String {
    // https://stackoverflow.com/questions/44102213/levenshtein-distance-in-swift3
    func levenshteinDistanceScoreTo(string: String, ignoreCase: Bool = true, trimWhiteSpacesAndNewLines: Bool = true) -> Float {
        
        var firstString = self
        var secondString = string
        
        if ignoreCase {
            firstString = firstString.lowercased()
            secondString = secondString.lowercased()
        }
        if trimWhiteSpacesAndNewLines {
            firstString = firstString.trimmingCharacters(in: .whitespacesAndNewlines)
            secondString = secondString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let empty = [Int](repeating:0, count: secondString.count)
        var last = [Int](0...secondString.count)
        
        for (i, tLett) in firstString.enumerated() {
            var cur = [i + 1] + empty
            for (j, sLett) in secondString.enumerated() {
                cur[j + 1] = tLett == sLett ? last[j] : Swift.min(last[j], last[j + 1], cur[j])+1
            }
            last = cur
        }
        
        // maximum string length between the two
        let lowestScore = max(firstString.count, secondString.count)
        
        if let validDistance = last.last {
            return  1 - (Float(validDistance) / Float(lowestScore))
        }
        
        return Float.leastNormalMagnitude
    }
}
