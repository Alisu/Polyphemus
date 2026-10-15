reading
handle

	"Its process handle, opened again when read after #close, as Linux opens /proc/<pid>/mem
	again: a reified memory reads on after its reader is closed."

	^ handle ifNil: [ handle := self class openProcess: 16r0C38 inherit: 0 pid: pid ]
