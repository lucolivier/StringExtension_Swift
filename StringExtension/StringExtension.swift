//
//  StringExtension.swift
//  StringExtension
//
//  Created by Luc-Olivier on 4/15/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

import Foundation


/* ============================================================================

ToDo: 

============================================================================ */


public enum StringExtensionExceptions : Error {
	case replaceString_StringToInsert_Void
	case replaceString_StringAnchor_Void
	
	case insertString_StringToInsert_Void
	case insertString_StringAnchor_Void
	
	case removeString_StringToRemove_Void
	
	case rangeOfString_VoidString
	case rangeOfString_BadOccurence
	
	case occurenceOfString_VoidString
	
	case stringWithChar_AmountToZero
	
	case unicodeScalar_VoidString
}

public extension String {
	enum StringExtensionResults {
		case undefined

		case replaceString_Success
		case replaceString_Exception
		
		case insertString_Success
		case insertString_Exception
		
		case removeString_Success
		case removeString_Exception
		
		case rangeOfString_StringFound
		case rangeOfString_StringNotFound
		case rangeOfString_LastStringOccurenceFound
		case rangeOfString_StringOccurenceFound
		case rangeOfString_StringFoundButOccurenceNotFound
		case rangeOfString_Exception
	}
	enum StringInsertMode {
		case before
		case after
	}

	mutating func replaceString(_ anchor: String, string: String, occurence: Int)  throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .undefined
		var err: Any?
		do {
			(result, err) = try String.replaceString(&self, anchor: anchor, string: string, occurence: occurence)
			//>> replaceString throw exception: No need to do that
			if (result == .replaceString_Success) {
				return (result, nil)
			}
			return (result, err)
			//<<
		} catch {
			return (.replaceString_Exception, error)
		}
	}
	public static func replaceString(_ target: inout String, anchor: String, string: String, occurence: Int)  throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.replaceString_StringToInsert_Void }
		if anchor.characters.count == 0 { throw StringExtensionExceptions.replaceString_StringAnchor_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .undefined
		do {
			(range, result) = try String.rangeOfString(target, string: anchor, occurence: occurence)
			if (range == nil) { return (result, nil) }
			target.replaceSubrange(range!, with: string.characters)
			return (.insertString_Success, nil)
		} catch {
			return (.replaceString_Exception, error)
			
		}
	}
	
	mutating func insertString(_ string: String, anchor: String, occurence: Int, mode: StringInsertMode) throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .undefined
		var err: Any?
		do {
			(result, err) = try String.insertString(&self, string: string, anchor: anchor, occurence: occurence, mode: mode)
			//>> insertString throw exception: No need to do that
			if (result == .insertString_Success) {
				return (result, nil)
			}
			return (result, err)
			//<<
		} catch {
			return (.insertString_Exception, error)
		}
	}
	public static func insertString(_ target: inout String, string: String, anchor: String, occurence: Int, mode: StringInsertMode) throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.insertString_StringToInsert_Void }
		if anchor.characters.count == 0 { throw StringExtensionExceptions.insertString_StringAnchor_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .undefined
		do {
			(range, result) = try String.rangeOfString(target, string: anchor, occurence: occurence)
			if (range == nil) { return (result, nil) }
			if (mode == .before) {
				target.insert(contentsOf: string.characters, at: range!.lowerBound)
			} else {
				target.insert(contentsOf: string.characters, at: range!.upperBound)
			}
			return (.insertString_Success, nil)
		} catch {
			return (.insertString_Exception, error)
		}
	}
	
	mutating func removeString (_ string: String, occurence: Int) throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .undefined
		var err: Any?
		do {
			(result, err) = try String.removeString(&self, string: string, occurence: occurence)
			if (result == .removeString_Exception) {
				return (result, err)
			}
			return (result, nil)
		} catch {
			return (.insertString_Exception, error)
		}
	}
	public static func removeString(_ target: inout String, string: String, occurence: Int) throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.removeString_StringToRemove_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .undefined
		do {
			(range, result) = try String.rangeOfString(target, string: string, occurence: occurence)
			if (range == nil) { return (result, nil) }
			target.removeSubrange(range!)
			return (.removeString_Success, nil)
		} catch {
			return (.removeString_Exception, error)
		}
	}
	
	mutating func removeDoubleSpace () { String.removeDoubleSpace(&self) }
	
	public static func removeDoubleSpace(_ target: inout String) {
		while let r = target.range(of: "  ") {
			target.remove(at: r.lowerBound)
		}
	}
	
	func rangeOfString(_ string: String, occurence: Int) throws -> (Range<Index>?, StringExtensionResults, Any?) {
		var range: Range<Index>? = nil
		var result: StringExtensionResults = .undefined
		do {
			(range, result) = try String.rangeOfString(self, string: string, occurence: occurence)
			return (range, result, nil)
		} catch {
			//return (nil, .RangeOfStringOccurence_Exception, error)
			throw error
		}
	}
	
	public static func rangeOfString(_ target: String, string: String, occurence: Int) throws -> (Range<Index>?, StringExtensionResults) {
		// 1=1st, -1=last, n=nth
		if string.characters.count == 0 { throw StringExtensionExceptions.rangeOfString_VoidString }
		if occurence < -1 { throw StringExtensionExceptions.rangeOfString_BadOccurence }
		
		var resultRange: Range<Index>?
        // Swift2
        // var currentRange = target.characters.indices
        //
        var currentRange = target.startIndex..<target.endIndex
		var resultName: StringExtensionResults = .undefined
		
		if occurence == 1 {
			resultRange = target.range(of: string)
			resultName = (resultRange != nil) ? .rangeOfString_StringFound : .rangeOfString_StringNotFound
			return (resultRange, resultName)
		} else {
			var cpt = 0
			
			var resultRangeBkp: Range<Index>?
			while (cpt != occurence) {
				
				resultRange = target.range(of: string, options: NSString.CompareOptions.literal, range: currentRange)
				
				if resultRange != nil {
					cpt += 1
					if (resultRange!.upperBound >= target.endIndex) {
						break
					}
                    // Swift2
					//currentRange?.lowerBound = index(resultRange!.upperBound, offsetBy: 1)
					//currentRange?.upperBound = target.endIndex
                    //
                    currentRange = target.index(after: resultRange!.upperBound)..<target.endIndex
                } else {
					break
				}
				resultRangeBkp = resultRange
			}
			if occurence == -1 {
				if (resultRange == nil) { resultRange = resultRangeBkp }
				resultName = (resultRange != nil) ? .rangeOfString_LastStringOccurenceFound : .rangeOfString_StringNotFound
			} else {
				if cpt == 0 {
					resultName = .rangeOfString_StringNotFound
				} else if cpt == occurence {
					resultName = .rangeOfString_StringOccurenceFound
				} else {
					resultRange = nil
					resultName = .rangeOfString_StringFoundButOccurenceNotFound
				}
			}
		}
		return (resultRange, resultName)
	}
	
	public static func stringWithChar(_ character: Character, amount: UInt) throws -> String {
		if (amount < 1) { throw StringExtensionExceptions.stringWithChar_AmountToZero }
		var res: String = ""
		let char = "\(character)"
		for _ in 1...amount {
			res = res + char
		}
		return res
	}
	
	func occuranceOfString(_ string: String) throws -> UInt {
		if string.characters.count == 0 { throw StringExtensionExceptions.occurenceOfString_VoidString }
		do {
		return try String.occuranceOfString(self, string: string)
		} catch {
			throw error
		}
	}
	
	public static func occuranceOfString(_ target: String, string: String) throws -> (UInt) {
		if string.characters.count == 0 { throw StringExtensionExceptions.occurenceOfString_VoidString }
		var resultRange: Range<Index>?
        // Swift2
		//var currentRange = target.characters.indices
        //
        var currentRange = target.startIndex..<target.endIndex
		var cpt: UInt = 0
		while true {
			resultRange = target.range(of: string, options: NSString.CompareOptions.literal, range: currentRange)
			if (resultRange == nil) { break }
			cpt += 1
			if (resultRange!.upperBound >= target.endIndex) {
				break
			}
			//Swift2
            //currentRange.lowerBound = <#T##Collection corresponding to your index##Collection#>.index(resultRange!.upperBound, offsetBy: 1)
			//currentRange.upperBound = target.endIndex
            //
            currentRange = target.index(after: resultRange!.upperBound)..<target.endIndex
        }
		return cpt
	}
	
	func unicodeScalar() throws -> (UInt32) {
		if (self == "") { throw StringExtensionExceptions.unicodeScalar_VoidString }
		let range = self.startIndex..<self.characters.index(self.startIndex, offsetBy: 1)
		let char = self.substring(with: range)
		return String.unicodeScalarCharValue(Character(char))
	}
	
	public static func unicodeScalarCharValue(_ character: Character) -> (UInt32) {
		let string: String = "\(character)"
		var result: UInt32 = 0
		for scalar in string.unicodeScalars {
			result = scalar.value
			break
		}
		return result
	}
	
	func unicodeUTF8() -> [UTF8Char] { return String.unicodeUTF8(self) }
	
	public static func unicodeUTF8(_ string: String) -> [UTF8Char] {
		var result: [UTF8Char] = []
		for utf8: UTF8Char in string.utf8 {
			result.append(utf8)
		}
		return result
	}
	
	func unicodeUTF16() -> [UTF16Char] { return String.unicodeUTF16(self) }
	
	public static func unicodeUTF16(_ string: String) -> [UTF16Char] {
		var result: [UTF16Char] = []
		for utf16: UTF16Char in string.utf16 {
			result.append(utf16)
		}
		return result
	}

	func unicodeUTF32() -> [UInt32] { return String.unicodeUTF32(self) }
	
	public static func unicodeUTF32(_ string: String) -> [UInt32] {
		var result: [UInt32] = []
		for scalar in string.unicodeScalars {
			result.append(scalar.value)
		}
		return result
	}
	
}

