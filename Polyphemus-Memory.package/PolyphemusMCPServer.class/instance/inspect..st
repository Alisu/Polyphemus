tools
inspect: someArguments

	| reified address object names slots indexable limit structured |
	reified := (self imageAt: someArguments) reified.
	address := someArguments at: 'address' ifAbsent: [ ToolCallFailed signal: 'inspect needs an address' ].
	object := [ reified reifyOop: address ] on: PolyphemusError do: [ :e | nil ].
	(object notNil and: [ [ object isObjectOop and: [ object isReadable ] ] on: PolyphemusError do: [ :e | false ] ]) ifFalse: [
		ToolCallFailed signal: 'No object at ' , address printString , ' in ' , (someArguments at: 'handle') ].
	names := [ object oopClass allInstVarNames asArray ] on: PolyphemusError do: [ :e | #(  ) ].
	slots := OrderedCollection new.
	(object oopFormat between: 0 and: 5) ifTrue: [
		limit := (someArguments at: 'limit' ifAbsent: [ 20 ]) max: 0.
		indexable := object oopNumberOfSlots - names size.
		1 to: (names size + (indexable min: limit) min: object oopNumberOfSlots) do: [ :i |
			slots add: (self slot: i of: object named: (names at: i ifAbsent: [ nil ])) ] ].
	structured := Dictionary new
		              at: 'address' put: address;
		              at: 'class' put: object oopClassName;
		              at: 'format' put: object oopFormatName asString;
		              at: 'slotCount' put: object oopNumberOfSlots;
		              at: 'slots' put: slots asArray;
		              yourself.
	object isStringOop ifTrue: [ structured at: 'string' put: (object asString in: [ :string | string size > 2000 ifTrue: [ (string first: 2000) , '...' ] ifFalse: [ string ] ]) ].
	^ self
		  text: (String streamContents: [ :s |
				   s << object oopClassName << ' at ' << address printString << ', ' << object oopNumberOfSlots printString << ' slots'.
				   (structured at: 'string' ifAbsent: [ nil ]) ifNotNil: [ :string | s << ': ' << string printString ].
				   slots do: [ :each |
					   s lf << ((each at: 'name') ifNil: [ (each at: 'index') printString ]) << ' = ' << (each at: 'value').
					   (each at: 'address') ifNotNil: [ :a | s << '  @' << a printString ] ] ])
		  structured: structured
