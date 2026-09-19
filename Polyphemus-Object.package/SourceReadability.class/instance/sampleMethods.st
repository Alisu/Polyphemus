checking
sampleMethods

	"The home methods of what the processes were running, at most thirty: the methods
	anyone reading this memory will want the source of first."

	| methods |
	methods := Dictionary new.
	([ memory allReifiedProcesses ] on: Error do: [ :e | #(  ) ]) do: [ :process |
		([ memory activationsOfProcess: process ] on: Error do: [ :e | #(  ) ]) do: [ :each |
			methods size < 30 ifTrue: [
				[ | home |
				  home := memory homeMethodOf: each compiledCode.
				  methods at: home address put: home ] on: Error do: [ :e | nil ] ] ] ].
	^ methods values
