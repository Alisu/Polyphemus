instance creation
on: aPid

	"A reader for another process, or CannotReadProcess saying why: no such process, not a
	Pharo VM, or the system refused. Pharo reports a refused /proc/<pid>/mem as missing."

	| reader |
	reader := self new setPid: aPid; yourself.
	reader exists ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #noSuchProcess) signal ].
	reader isPharoVirtualMachine ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #notAPharoVirtualMachine) signal ].
	reader canBeRead ifFalse: [
		^ (CannotReadProcess new pid: aPid reason: #theOperatingSystemRefused) signal ].
	^ reader
