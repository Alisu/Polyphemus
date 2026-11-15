checking
sampleMethods

	"The home methods of what the processes were running, at most thirty: the methods anyone
	reading this memory will want the source of first. An activation whose method does not read
	is left out; processes that do not read are refused by name."

	| methods |
	methods := Dictionary new.
	memory allReifiedProcesses do: [ :process |
		(memory activationsOfProcess: process) do: [ :each |
			methods size < 30 ifTrue: [
				[
				| home |
				home := memory stacks homeMethodOf: each compiledCode.
				methods at: home address put: home ]
					on: PolyphemusError
					do: [ :refusal | nil ] ] ] ].
	^ methods values
