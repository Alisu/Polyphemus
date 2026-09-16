enumerating
ptraceScope

	"What Yama is set to, or nil where there is no Yama.

	0 lets any process of the same user read another. 1, which is the usual default and what
	this box has, lets only an *ancestor*. 2 and 3 are stricter still."

	| file |
	file := '/proc/sys/kernel/yama/ptrace_scope' asFileReference.
	^ file exists ifTrue: [ file contents trimBoth asNumber ] ifFalse: [ nil ]
