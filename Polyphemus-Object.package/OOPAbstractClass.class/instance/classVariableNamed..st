variables
classVariableNamed: aName

	"A class variable of the image being read, wrapped as one of ours. They are not globals
	and they are not instance variables, and until they were looked up here every name that
	was one -- LowSpaceProcess, FinalizationSemaphore, SpecialSelectors -- came back
	unresolved, was painted as unknown, and was written into THIS image's Undeclared.

	Looked up the way the other image would: this class first, then up its superclasses. The
	wrapper is kept by the memory, under the class that declares it, so that the same
	variable is always the same object."

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
