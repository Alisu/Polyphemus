variables
classVariableNamed: aName

	"A class variable of the image being read, looked up in this class then its superclasses,
	wrapped once per declaring class."

	| wanted |
	wanted := aName asString.
	({ self } , ([ self oopSuperclasses ] on: PolyphemusError do: [ :refusal | #(  ) ])) do: [ :current |
		| names |
		names := [ current oopAllClassVariablesNames collect: [ :each | each asString ] ]
			         on: PolyphemusError
			         do: [ :e | #(  ) ].
		(names includes: wanted) ifTrue: [
			^ memory
				  wrappedVariableAt: 'classVar.' , current address printString , '.' , wanted
				  ifAbsentPut: [
					  (Smalltalk at: #ClassVariable ifAbsent: [ GlobalVariable ])
						  key: wanted asSymbol
						  value: ([ current oopClassVariableNamed: wanted ]
								   on: PolyphemusError
								   do: [ :e | OOPUnreadableSlot named: wanted because: e messageText asString on: memory ]) ] ] ].
	^ nil
