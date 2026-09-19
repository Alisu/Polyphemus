reading
state

	"The kernel's state letter from /proc/<pid>/status: R, S, T for stopped, Z. The field is
	tab separated."

	^ [
	  (((self pathFor: 'status') asFileReference contents lines detect: [ :each |
		    each beginsWith: 'State:' ]) substrings at: 2) first ]
		  on: Error
		  do: [ :e | nil ]
