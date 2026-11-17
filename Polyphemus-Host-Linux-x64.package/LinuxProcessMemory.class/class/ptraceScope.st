enumerating
ptraceScope

	"What Yama is set to, or nil without Yama: 0 lets any process of the user read another,
	1 (the usual default) only an ancestor, 2 and 3 stricter still."

	| file |
	file := '/proc/sys/kernel/yama/ptrace_scope' asFileReference.
	^ file exists ifTrue: [ file contents trimBoth asNumber ] ifFalse: [ nil ]
