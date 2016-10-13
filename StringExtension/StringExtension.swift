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


public enum StringExtensionExceptions : ErrorType {
	case ReplaceString_StringToInsert_Void
	case ReplaceString_StringAnchor_Void
	
	case InsertString_StringToInsert_Void
	case InsertString_StringAnchor_Void
	
	case RemoveString_StringToRemove_Void
	
	case RangeOfString_VoidString
	case RangeOfString_BadOccurence
	
	case OccurenceOfString_VoidString
	
	case StringWithChar_AmountToZero
	
	case UnicodeScalar_VoidString
}

public extension String {
	enum StringExtensionResults {
		case Undefined

		case ReplaceString_Success
		case ReplaceString_Exception
		
		case InsertString_Success
		case InsertString_Exception
		
		case RemoveString_Success
		case RemoveString_Exception
		
		case RangeOfString_StringFound
		case RangeOfString_StringNotFound
		case RangeOfString_LastStringOccurenceFound
		case RangeOfString_StringOccurenceFound
		case RangeOfString_StringFoundButOccurenceNotFound
		case RangeOfString_Exception
	}
	enum StringInsertMode {
		case Before
		case After
	}

	mutating func replaceString(anchor: String, string: String, occurence: Int)  throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .Undefined
		var err: Any?
		do {
			(result, err) = try String.replaceString(&self, anchor: anchor, string: string, occurence: occurence)
			//>> replaceString throw exception: No need to do that
			if (result == .ReplaceString_Success) {
				return (result, nil)
			}
			return (result, err)
			//<<
		} catch {
			return (.ReplaceString_Exception, error)
		}
	}
	public static func replaceString(inout target: String, anchor: String, string: String, occurence: Int)  throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.ReplaceString_StringToInsert_Void }
		if anchor.characters.count == 0 { throw StringExtensionExceptions.ReplaceString_StringAnchor_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .Undefined
		do {
			(range, result) = try String.rangeOfString(target, string: anchor, occurence: occurence)
			if (range == nil) { return (result, nil) }
			target.replaceRange(range!, with: string.characters)
			return (.InsertString_Success, nil)
		} catch {
			return (.ReplaceString_Exception, error)
			
		}
	}
	
	mutating func insertString(string: String, anchor: String, occurence: Int, mode: StringInsertMode) throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .Undefined
		var err: Any?
		do {
			(result, err) = try String.insertString(&self, string: string, anchor: anchor, occurence: occurence, mode: mode)
			//>> insertString throw exception: No need to do that
			if (result == .InsertString_Success) {
				return (result, nil)
			}
			return (result, err)
			//<<
		} catch {
			return (.InsertString_Exception, error)
		}
	}
	public static func insertString(inout target: String, string: String, anchor: String, occurence: Int, mode: StringInsertMode) throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.InsertString_StringToInsert_Void }
		if anchor.characters.count == 0 { throw StringExtensionExceptions.InsertString_StringAnchor_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .Undefined
		do {
			(range, result) = try String.rangeOfString(target, string: anchor, occurence: occurence)
			if (range == nil) { return (result, nil) }
			if (mode == .Before) {
				target.insertContentsOf(string.characters, at: range!.startIndex)
			} else {
				target.insertContentsOf(string.characters, at: range!.endIndex)
			}
			return (.InsertString_Success, nil)
		} catch {
			return (.InsertString_Exception, error)
		}
	}
	
	mutating func removeString (string: String, occurence: Int) throws -> (StringExtensionResults, Any?) {
		var result: StringExtensionResults = .Undefined
		var err: Any?
		do {
			(result, err) = try String.removeString(&self, string: string, occurence: occurence)
			if (result == .RemoveString_Exception) {
				return (result, err)
			}
			return (result, nil)
		} catch {
			return (.InsertString_Exception, error)
		}
	}
	public static func removeString(inout target: String, string: String, occurence: Int) throws -> (StringExtensionResults, Any?) {
		if string.characters.count == 0 { throw StringExtensionExceptions.RemoveString_StringToRemove_Void }
		var range: Range<Index>?
		var result: StringExtensionResults = .Undefined
		do {
			(range, result) = try String.rangeOfString(target, string: string, occurence: occurence)
			if (range == nil) { return (result, nil) }
			target.removeRange(range!)
			return (.RemoveString_Success, nil)
		} catch {
			return (.RemoveString_Exception, error)
		}
	}
	
	mutating func removeDoubleSpace () { String.removeDoubleSpace(&self) }
	
	public static func removeDoubleSpace(inout target: String) {
		while let r = target.rangeOfString("  ") {
			target.removeAtIndex(r.startIndex)
		}
	}
	
	func rangeOfString(string: String, occurence: Int) throws -> (Range<Index>?, StringExtensionResults, Any?) {
		var range: Range<Index>? = nil
		var result: StringExtensionResults = .Undefined
		do {
			(range, result) = try String.rangeOfString(self, string: string, occurence: occurence)
			return (range, result, nil)
		} catch {
			//return (nil, .RangeOfStringOccurence_Exception, error)
			throw error
		}
	}
	
	public static func rangeOfString(target: String, string: String, occurence: Int) throws -> (Range<Index>?, StringExtensionResults) {
		// 1=1st, -1=last, n=nth
		if string.characters.count == 0 { throw StringExtensionExceptions.RangeOfString_VoidString }
		if occurence < -1 { throw StringExtensionExceptions.RangeOfString_BadOccurence }
		
		var resultRange: Range<Index>?
		var currentRange = target.startIndex..<target.endIndex
		var resultName: StringExtensionResults = .Undefined
		
		if occurence == 1 {
			resultRange = target.rangeOfString(string)
			resultName = (resultRange != nil) ? .RangeOfString_StringFound : .RangeOfString_StringNotFound
			return (resultRange, resultName)
		} else {
			var cpt = 0
			
			var resultRangeBkp: Range<Index>?
			while (cpt != occurence) {
				
				resultRange = target.rangeOfString(string, options: NSStringCompareOptions.LiteralSearch, range: currentRange)
				
				if resultRange != nil {
					cpt += 1
					if (resultRange!.endIndex >= target.endIndex) {
						break
					}
					currentRange.startIndex = resultRange!.endIndex.advancedBy(1)
					currentRange.endIndex = target.endIndex
				} else {
					break
				}
				resultRangeBkp = resultRange
			}
			if occurence == -1 {
				if (resultRange == nil) { resultRange = resultRangeBkp }
				resultName = (resultRange != nil) ? .RangeOfString_LastStringOccurenceFound : .RangeOfString_StringNotFound
			} else {
				if cpt == 0 {
					resultName = .RangeOfString_StringNotFound
				} else if cpt == occurence {
					resultName = .RangeOfString_StringOccurenceFound
				} else {
					resultRange = nil
					resultName = .RangeOfString_StringFoundButOccurenceNotFound
				}
			}
		}
		return (resultRange, resultName)
	}
	
	public static func stringWithChar(character: Character, amount: UInt) throws -> String {
		if (amount < 1) { throw StringExtensionExceptions.StringWithChar_AmountToZero }
		var res: String = ""
		let char = "\(character)"
		for _ in 1...amount {
			res = res + char
		}
		return res
	}
	
	func occuranceOfString(string: String) throws -> UInt {
		if string.characters.count == 0 { throw StringExtensionExceptions.OccurenceOfString_VoidString }
		do {
		return try String.occuranceOfString(self, string: string)
		} catch {
			throw error
		}
	}
	
	public static func occuranceOfString(target: String, string: String) throws -> (UInt) {
		if string.characters.count == 0 { throw StringExtensionExceptions.OccurenceOfString_VoidString }
		var resultRange: Range<Index>?
		var currentRange = target.startIndex..<target.endIndex
		var cpt: UInt = 0
		while true {
			resultRange = target.rangeOfString(string, options: NSStringCompareOptions.LiteralSearch, range: currentRange)
			if (resultRange == nil) { break }
			cpt += 1
			if (resultRange!.endIndex >= target.endIndex) {
				break
			}
			currentRange.startIndex = resultRange!.endIndex.advancedBy(1)
			currentRange.endIndex = target.endIndex
		}
		return cpt
	}
	
	func unicodeScalar() throws -> (UInt32) {
		if (self == "") { throw StringExtensionExceptions.UnicodeScalar_VoidString }
		let range = self.startIndex..<self.startIndex.advancedBy(1)
		let char = self.substringWithRange(range)
		return String.unicodeScalarCharValue(Character(char))
	}
	
	public static func unicodeScalarCharValue(character: Character) -> (UInt32) {
		let string: String = "\(character)"
		var result: UInt32 = 0
		for scalar in string.unicodeScalars {
			result = scalar.value
			break
		}
		return result
	}
	
	func unicodeUTF8() -> [UTF8Char] { return String.unicodeUTF8(self) }
	
	public static func unicodeUTF8(string: String) -> [UTF8Char] {
		var result: [UTF8Char] = []
		for utf8: UTF8Char in string.utf8 {
			result.append(utf8)
		}
		return result
	}
	
	func unicodeUTF16() -> [UTF16Char] { return String.unicodeUTF16(self) }
	
	public static func unicodeUTF16(string: String) -> [UTF16Char] {
		var result: [UTF16Char] = []
		for utf16: UTF16Char in string.utf16 {
			result.append(utf16)
		}
		return result
	}

	func unicodeUTF32() -> [UInt32] { return String.unicodeUTF32(self) }
	
	public static func unicodeUTF32(string: String) -> [UInt32] {
		var result: [UInt32] = []
		for scalar in string.unicodeScalars {
			result.append(scalar.value)
		}
		return result
	}
	
}

