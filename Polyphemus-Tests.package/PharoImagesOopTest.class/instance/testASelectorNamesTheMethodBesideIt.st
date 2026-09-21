tests
testASelectorNamesTheMethodBesideIt

	"#28: the dictionary's own first two slots are its tally and its array, and its selectors
	follow; the methods are in that array from slot one. So selector 2 + i goes with method i,
	which is what MethodDictionary>>scanFor: assumes -- checked here for every one Integer has."

	| dictionary methods |
	dictionary := (reifiedMemory oopClassNamed: 'Integer') reifiedSlotAt: 2.
	methods := dictionary reifiedSlotAt: 2.

	1 to: methods oopNumberOfSlots do: [ :index |
		| method |
		method := methods reifiedSlotAt: index.
		method isNilOop ifFalse: [
			self
				assert: method oopSelector asString
				equals: (dictionary reifiedSlotAt: index + 2) asString ] ]
