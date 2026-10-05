initialization
setTask: aTaskDirectory files: someMappedFiles codeZone: anAssociationOrNil

	"From /proc/<pid>/task/<tid>: its state (stat), and its system call with its arguments, sp
	and pc (syscall: -1 for a thread stopped outside one, running for one that runs)."

	| stat fields |
	id := aTaskDirectory basename asNumber.
	stat := [ (aTaskDirectory / 'stat') contents ] on: Error do: [ :e | '' ].
	state := (stat copyAfterLast: $)) trimBoth ifEmpty: [ '?' ] ifNotEmpty: [ :rest | rest first asString ].
	fields := ([ (aTaskDirectory / 'syscall') contents trimBoth ] on: Error do: [ :e | 'running' ]) substrings: ' '.
	wasRunning := fields first = 'running'.
	fields size >= 3 ifTrue: [
		number := fields first asNumber.
		arguments := (fields copyFrom: 2 to: fields size - 2) collect: [ :each | self hexValueOf: each ].
		sp := self hexValueOf: (fields at: fields size - 1).
		pc := self hexValueOf: fields last.
		location := self class locationOf: pc codeZone: anAssociationOrNil files: someMappedFiles ]
