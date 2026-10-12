tools
slot: anIndex of: anObject named: aName

	| value |
	value := [ anObject reifiedSlotAt: anIndex ] on: Error do: [ :e | nil ].
	^ Dictionary new
		  at: 'index' put: anIndex;
		  at: 'name' put: aName;
		  at: 'value' put: (value ifNil: [ '(unreadable)' ] ifNotNil: [ self describe: value ]);
		  at: 'address' put: (value ifNotNil: [ [ self addressOf: value ] on: Error do: [ :e | nil ] ]);
		  yourself
