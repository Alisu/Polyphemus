tools
rowOfTemporary: aName readBy: aBlock

	"One temporary of a stack row: its name if it has one here, what it holds and where. Read
	once: by name, a read follows temp vectors and outer activations (#191)."

	| read held |
	read := true.
	held := aBlock on: PolyphemusError do: [ :refusal |
		        read := false.
		        nil ].
	^ Dictionary new
		  at: 'name' put: aName;
		  at: 'value' put: (read
				   ifTrue: [ [ self describe: held ] on: PolyphemusError do: [ :e | '(unreadable)' ] ]
				   ifFalse: [ '(unreadable)' ]);
		  at: 'address' put: (read
				   ifTrue: [ [ self addressOf: held ] on: PolyphemusError do: [ :e | nil ] ]
				   ifFalse: [ nil ]);
		  yourself
