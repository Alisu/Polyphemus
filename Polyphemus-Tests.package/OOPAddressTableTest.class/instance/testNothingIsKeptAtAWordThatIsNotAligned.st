tests
testNothingIsKeptAtAWordThatIsNotAligned

	"A put that rounded the word down would write over the object before it."

	table at: 16r340000008 put: #young.
	self should: [ table at: 16r34000000C put: #other ] raise: NotInTheReading.
	self assert: (table at: 16r340000008) equals: #young.
	self assert: (table select: [ :each | each notNil ]) asArray equals: #( #young )
