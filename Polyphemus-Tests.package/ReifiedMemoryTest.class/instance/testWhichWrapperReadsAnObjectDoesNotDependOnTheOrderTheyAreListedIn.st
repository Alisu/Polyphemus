tests
testWhichWrapperReadsAnObjectDoesNotDependOnTheOrderTheyAreListedIn

	"#118: several wrappers may claim one object (a string is bytes too), and the last listed was
	taken: listed in the order the image gave its classes, which nothing fixes. The most specific
	is taken, whatever the order (the same on 135,000 objects of two memories, measured)."

	| handlers aString |
	handlers := reifiedMemory instVarNamed: #objectHandlers.
	reifiedMemory memoryManager allOldSpaceObjectsDo: [ :oop |
		(aString isNil and: [ (reifiedMemory handlerToUseFor: oop) == OOPString ]) ifTrue: [ aString := oop ] ].
	self assert: aString notNil.
	[
	reifiedMemory instVarNamed: #objectHandlers put: handlers reversed.
	self assert: (reifiedMemory handlerToUseFor: aString) identicalTo: OOPString.
	reifiedMemory instVarNamed: #objectHandlers put: (handlers asSortedCollection: [ :a :b | a name <= b name ]) asOrderedCollection.
	self assert: (reifiedMemory handlerToUseFor: aString) identicalTo: OOPString ] ensure: [
		reifiedMemory instVarNamed: #objectHandlers put: handlers ]
