tools
rowOfTemporary: aName readBy: aBlock

	"One temporary of a stack row: its name if it has one here, what it holds and where."

	^ Dictionary new
		  at: 'name' put: aName;
		  at: 'value' put: ([ self describe: aBlock value ] on: PolyphemusError do: [ :e | '(unreadable)' ]);
		  at: 'address' put: ([ self addressOf: aBlock value ] on: PolyphemusError do: [ :e | nil ]);
		  yourself