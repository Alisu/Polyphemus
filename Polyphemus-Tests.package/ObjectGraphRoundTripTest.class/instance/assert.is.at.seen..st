helpers
assert: anOop is: anObject at: aPath seen: aDictionary

	"anOop, read from the target, is what anObject is here: the same class, size and values,
	and the same object wherever anObject is met again (aDictionary: our object -> its address)."

	| where |
	where := [ aPath , ': ' , (anObject printString contractTo: 60) , ' read as ' , anOop printString ].
	(anObject isInteger or: [ anObject isCharacter ]) ifTrue: [
		^ self assert: anOop printString = anObject printString description: where ].
	(anObject isNil or: [ anObject == true or: [ anObject == false ] ]) ifTrue: [
		^ self assert: anOop oopClassName = anObject class name description: where ].
	self assert: anOop oopClassName = anObject class name description: where.
	(aDictionary includesKey: anObject) ifTrue: [
		^ self assert: (aDictionary at: anObject) = anOop address description: [ where value , ', not the object met before' ] ].
	self
		assert: (aDictionary keyAtValue: anOop address ifAbsent: [ nil ]) isNil
		description: [ where value , ', the object another path read too' ].
	aDictionary at: anObject put: anOop address.
	anObject isString ifTrue: [
		^ self assert: anOop asString = anObject asString description: [
			  aPath , ': characters ' , (anObject asArray collect: [ :each | each asInteger ]) printString , ' read as '
			  , (anOop asString asArray collect: [ :each | each asInteger ]) printString ] ].
	((anObject isKindOf: ByteArray) or: [ (anObject isKindOf: WordArray) or: [ anObject isKindOf: DoubleByteArray ] ]) ifTrue: [
		self assert: anOop oopNumberOfIndexed = anObject size description: where.
		^ anObject doWithIndex: [ :each :index |
			  self assert: (anOop indexedAt: index) = each description: [ where value , ' at ' , index printString ] ] ].
	self assert: anOop oopNumberOfSlots = anObject size description: where.
	anObject doWithIndex: [ :each :index |
		self assert: (anOop reifiedSlotAt: index) is: each at: aPath , '.' , index printString seen: aDictionary ]
