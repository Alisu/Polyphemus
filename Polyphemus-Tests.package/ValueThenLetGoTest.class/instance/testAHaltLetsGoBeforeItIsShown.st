tests
testAHaltLetsGoBeforeItIsShown

	"A halt in a held block opens a debugger as an error does: the process is let go first, or it
	stays stopped behind that debugger (#96)."

	| letGo seenLetGo |
	letGo := false.
	[ [ Halt signal ] valueThenLetGo: [ letGo := true ] ] on: Halt do: [ :halt | seenLetGo := letGo ].
	self assert: seenLetGo
