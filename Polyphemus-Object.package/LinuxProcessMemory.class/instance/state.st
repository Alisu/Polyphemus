reading
state

	"What the kernel says this process is doing, as a single letter: R running, S sleeping,
	T stopped, Z a zombie. Read from `/proc/<pid>/status`, which is readable whether or not
	the memory is.

	The line is `State:` then a tab then the letter, so it is split on whitespace rather than
	on spaces -- splitting on spaces alone leaves the tab attached and answers the first
	character of `(sleeping)`."

	^ [
	  (((self pathFor: 'status') asFileReference contents lines detect: [ :each |
		    each beginsWith: 'State:' ]) substrings at: 2) first ]
		  on: Error
		  do: [ :e | nil ]
