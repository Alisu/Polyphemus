instance creation
on: aPid

	"A reader for another process, or a refusal saying which of the three things was wrong:
	there is no such process, it is not a Pharo virtual machine, or the operating system
	will not let us look at it.

	The last is worth telling apart from the first, because Pharo reports a refused open of
	`/proc/<pid>/mem` as the file not existing -- and it does exist; we are simply not
	allowed it."

	| reader |
	reader := self new setPid: aPid; yourself.
	reader exists ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #noSuchProcess) signal ].
	reader isPharoVirtualMachine ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #notAPharoVirtualMachine) signal ].
	reader canBeRead ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #theOperatingSystemRefused) signal ].
	^ reader
