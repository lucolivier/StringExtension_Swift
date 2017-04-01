//
//  main.swift
//  StringExtension
//
//  Created by Luc-Olivier on 4/15/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

import Foundation

//
//  main.swift
//  15-6-String Extension Tools
//
//  Created by Luc-Olivier on 4/14/16.
//  Copyright © 2016 Luc-Olivier. All rights reserved.
//

import Foundation


print("----------------")

//do {
//	print(try "😇".unicodeScalarCharValue())
//	print(try "🇻🇳".unicodeScalarCharValue())
//	print(String.unicodeScalarCharValue(Character("⛳️")))
//} catch {
//	print(error)
//}

//let astring = "smilie: 😇 & •🇻🇳"
//var cpt = 0
//for item in astring.unicodeUTF8() {
//	print("\(item)")
//	cpt += 1
//}
//print(">>>\(cpt)")
//print("----------------")
//cpt = 0
//for item in astring.unicodeUTF16() {
//	print("\(item)")
//	cpt += 1
//}
//print(">>>\(cpt)")
//print("----------------")
//cpt = 0
//for item in astring.unicodeUTF32() {
//	print("\(item)")
//	cpt += 1
//}
//print(">>>\(cpt)")

//do {
//	print( try String.stringWithChar("•", amount: 20))
//} catch {
//	print(error)
//}


print("----------------------------")
print("#occuranceOfString")

var string2 = "If the world is the best place to leave, the ocean is the most important surface"
do {
	//print(try String.occuranceOfString(string2, string: "the"))
	print(try string2.occuranceOfString("the"))
} catch {
	print(error)
}

print("----------------------------")
print("#rangeOfString")

var text0 = "The most important thing the chicken 🐔 must know before to cross the road is that it does not if the road is realy a road!"
//var text0 = "to-to1111"
do {
	//let (r,res) = try String.rangeOfString(text0, string: "the", occurence: -1)
	let (r,res,error) = try text0.rangeOfString("to", occurence: -1)

	if r != nil {
		//print("\(r!.startIndex) - \(r!.endIndex)")
        print("\(r!.lowerBound) - \(r!.upperBound)")

	} else {
		if (res == String.StringExtensionResults.rangeOfString_Exception) {
			print(error!)
		} else {
			print(res)
		}
	}

} catch {
	print (error)
}

var string0 = "Hello, World, great World"
let (r,res,error) = try string0.rangeOfString("Wor-ld", occurence: 3)
if r != nil {
	//print("\(r!.startIndex) - \(r!.endIndex)")
    print("\(r!.lowerBound) - \(r!.upperBound)")
} else {
	if (res == String.StringExtensionResults.rangeOfString_Exception) {
		print(error!)
	} else {
		print(res)
	}
}

print("----------------------------")
print("#rangeOfString with occurence")

//var text = "The most important thing the chicken 🐔 must know before to cross the road is that it does not if the road is realy a road!"
var text = "to-to1111"
do {
	//let (r,res) = try String.rangeOfString(text, string: "the", occurence: -1)
	let (r,res,error) = try text.rangeOfString("to", occurence: -1)

	if r != nil {
		//print("\(r!.startIndex) - \(r!.endIndex)")
        print("\(r!.lowerBound) - \(r!.upperBound)")

	} else {
		if (res == String.StringExtensionResults.rangeOfString_Exception) {
			print(error!)
		} else {
			print(res)
		}
	}

} catch {
	print (error)
}
print ("--")

var string = "Hello, World, great World"
let (r0,res0,error0) = try string.rangeOfString("Wor-ld", occurence: 3)
if r0 != nil {
	//print("\(r0!.startIndex) - \(r0!.endIndex)")
    print("\(r0!.lowerBound) - \(r0!.upperBound)")
} else {
	if (res == String.StringExtensionResults.rangeOfString_Exception) {
		print(error0!)
	} else {
		print(res0)
	}
}

print("----------------------------")
print("#removeDoubleSpace")

var str2 = "Hello,  World   !"
str2.removeDoubleSpace()
print(str2)

print("----------------------------")
print("#removeString")

var strrem = "Hello, !World!"

do {
	//let (res, error) = try String.removeString(&strrem, string: "!", occurence: 1)
	let (res, error) = try strrem.removeString("!", occurence: 2)
	if (res == String.StringExtensionResults.removeString_Exception) {
		print(error!)
	} else {
		print(res)
	}
} catch {
	print(error)
}
print(strrem)

print("----------------------------")
print("#insertString")

var strins = "Hello, !World!"

do {
	//let (res,error) = try String.insertString(&strins, string: " Hello,", anchor: "World", occurence: 1, mode: String.StringInsertMode.After)
	let (res,error) = try strins.insertString(" Hello,", anchor: "World", occurence: 1, mode: String.StringInsertMode.after)
	if (res == String.StringExtensionResults.insertString_Exception) {
		print(error!)
	} else {
		print(res)
	}
} catch {
	print(error)
}
print(strins)


print("----------------------------")
print("#replaceString")

var strrep = "Hello, !World!"

do {
	//let (res, error) = try String.replaceString(&strrep, anchor: "!", string: "!!!", occurence: 1)
	let (res, error) = try strrep.replaceString("!", string: "!!!", occurence: 1)
	if (res == String.StringExtensionResults.removeString_Exception) {
		print(error!)
	} else {
		print(res)
	}
} catch {
	print(error)
}
print(strrep)


