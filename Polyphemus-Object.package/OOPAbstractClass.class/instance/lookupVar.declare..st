variables
lookupVar: aName declare: aBoolean

	"Resolve a name against this class so that source read out of a snapshot can be
	understood, in the order the image being read would resolve it: its own instance
	variables, then its class variables, then its globals.

	What comes back is a variable object of THIS image describing a variable of THAT one,
	because the tooling asking -- the compiler, the syntax highlighter, the debugger -- only
	understands its own. The layout walk is from the hackDebugger branch.

	The index matters: it is the one the variable has over there, and code generated here
	from that source has to read the same slot to mean the same thing."

	| layout index classVariable |
	layout := self reifiedSlotAt: 4.
	(self acceptableLayout includes: layout oopClassName) ifFalse: [
		index := self allInstVarNames indexOf: aName asString.
		index isZero ifFalse: [
			^ (InstanceVariableSlot named: aName asString asSymbol)
				  index: index;
				  yourself ] ].

	classVariable := self classVariableNamed: aName.
	classVariable ifNotNil: [ ^ classVariable ].

	^ self lookupReservedOrGlobal: aName
