accessing
systemCallName

	"nil outside a system call (running, or stopped in user code)."

	^ (number isNil or: [ number < 0 ]) ifTrue: [ nil ] ifFalse: [ StuckReport nameOfSystemCall: number ]
