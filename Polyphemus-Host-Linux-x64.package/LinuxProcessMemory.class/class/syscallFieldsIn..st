reading
syscallFieldsIn: aTaskDirectory

	"The fields of /proc/<pid>/task/<tid>/syscall: a call's number, its arguments, sp and pc; -1, sp
	and pc outside a call; running alone for a thread that runs. A file that does not read, or is
	empty, is its thread ended: one that runs, nothing being known of where it is (#212)."

	^ (([ (aTaskDirectory / 'syscall') contents trimBoth ]
		    on: Error
		    do: [ :gone | 'running' ]) substrings: ' ') ifEmpty: [ #( 'running' ) ]
