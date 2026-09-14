variables
lookupVar: aName declare: aBoolean

	"Resolve a name against this class so that source read out of a snapshot can be
	understood: instance variables come from the class layout of the image the method
	came from.

	What comes back is a variable object of THIS image describing a variable of THAT
	one, because the tooling asking, the syntax highlighter and the compiler, only
	understands its own. The layout walk is from the hackDebugger branch.

	The index matters: it is the one the variable has over there, and code generated
	here from that source has to read the same slot to mean the same thing."

	| layout index |
	layout := self reifiedSlotAt: 4.
	(self acceptableLayout includes: layout oopClassName) ifTrue: [
		^ self lookupReservedOrGlobal: aName ].

	index := self allInstVarNames indexOf: aName asString.
	index isZero ifFalse: [
		^ (InstanceVariableSlot named: aName asString asSymbol)
			  index: index;
			  yourself ].

	^ self lookupReservedOrGlobal: aName
