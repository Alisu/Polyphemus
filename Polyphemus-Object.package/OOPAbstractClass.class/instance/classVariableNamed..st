variables
classVariableNamed: aName

	"A class variable of the image being read, looked up in this class then its superclasses,
	wrapped once per declaring class."

	| current wanted |
	wanted := aName asString.
	current := self.
	[ current isNil or: [ current isNilOop ] ] whileFalse: [
		| names |
		names := [ current oopAllClassVariablesNames collect: [ :each | each asString ] ]
			         on: PolyphemusError
			         do: [ :e | #(  ) ].
		(names includes: wanted) ifTrue: [
			| owner |
			owner := current.
			^ memory
				  wrappedVariableAt: 'classVar.' , owner address printString , '.' , wanted
				  ifAbsentPut: [
					  (Smalltalk at: #ClassVariable ifAbsent: [ GlobalVariable ])
						  key: wanted asSymbol
						  value: ([ owner oopClassVariableNamed: wanted ]
								   on: PolyphemusError
								   do: [ :e | OOPUnreadableSlot named: wanted because: e messageText asString on: memory ]) ] ].
		current := [ current oopSuperclass ] on: PolyphemusError do: [ :e | nil ] ].
	^ nil
