variables
lookupVar: aName declare: aBoolean

	"Resolve a name against this class so that source read out of a snapshot can be
	understood: instance variables come from the class layout of the image the method
	came from.

	What comes back is a variable object of THIS image describing a variable of THAT
	one, because the tooling asking, the syntax highlighter and the compiler, only
	understands its own. The layout walk is from the hackDebugger branch."

	| layout |
	layout := self reifiedSlotAt: 4.
	(self acceptableLayout includes: layout oopClassName) ifTrue: [
		^ self bindingOf: aName ].

	(self allInstVarNames includes: aName asString) ifTrue: [
		^ InstanceVariableSlot named: aName asString asSymbol ].

	^ self bindingOf: aName
