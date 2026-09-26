*Polyphemus-Edition-Pharo11
allOldSpaceEntitiesFrom: initialObject do: aBlock
	"VMMaker's own, but a zeroed header signals rather than asserts: a heap read from outside
	can hold one where a running VM never would. VMMaker v10.0.5 ends old space in its memory map."

	| prevObj prevPrevObj objOop limit |
	self assert: (self getMemoryMap isOldObject: initialObject).
	limit := self getMemoryMap oldSpaceEnd.
	prevPrevObj := prevObj := nil.
	objOop := initialObject.
	[self assert: objOop \\ self allocationUnit = 0.
	 self oop: objOop isLessThan: limit] whileTrue:
		[(self long64At: objOop) ~= 0 ifFalse: [OopIsNotAnObject new
		oop: objOop;
		signal].
		 aBlock value: objOop.
		 prevPrevObj := prevObj.
		 prevObj := objOop.
		 objOop := self objectAfter: objOop limit: limit].
	self touch: prevPrevObj.
	self touch: prevObj
