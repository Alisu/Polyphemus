variables
classVariableNamed: aName

	"A class variable of the image being read, looked up in this class then its superclasses,
	wrapped once per declaring class."

	| current wanted |
	wanted := aName asString.
	current := self.
	[ current isNil or: [ [ current isNilOop ] on: Error do: [ :e | true ] ] ] whileFalse: [
		| names |
		names := [ current oopAllClassVariablesNames collect: [ :each | each asString ] ]
			         on: Error
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
								   on: Error
								   do: [ :e | nil ]) ] ].
		current := [ current oopSuperclass ] on: Error do: [ :e | nil ] ].
	^ nil
