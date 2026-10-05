initialization
setTask: aTaskDirectory files: someMappedFiles

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
		location := (someMappedFiles
			             detect: [ :each | pc between: each start and: each stop - 1 ]
			             ifNone: [ nil ])
			            ifNil: [ 'anonymous memory (Cog''s code zone is such)' ]
			            ifNotNil: [ :file | file path asFileReference basename ] ]
