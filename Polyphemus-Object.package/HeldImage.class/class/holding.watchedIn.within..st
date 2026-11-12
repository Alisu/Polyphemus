instance creation
holding: aPid watchedIn: aDirectory within: aDuration

	"That image held on what it is busy with. Held again, three times at most, when the process
	caught at the stop had ended before the agent found it: one of a moment, not its business (#172)."

	| tries |
	tries := 0.
	^ [
	  | image |
	  image := self on: aPid watchedIn: aDirectory.
	  image holdWithin: aDuration.
	  image ]
		  on: ProcessEndedBeforeHeld
		  do: [ :ended |
			  (tries := tries + 1) < 3 ifFalse: [ ended pass ].
			  ended retry ]
