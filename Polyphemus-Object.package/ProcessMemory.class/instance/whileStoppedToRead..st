holding it still
whileStoppedToRead: aBlock

	"aBlock's value on the reader holding it still: quiet within about two seconds, as a reading has
	always been, else outside a collection, which a VM in a loop always comes to (#113)."

	^ [ self whileStoppedWhenQuiet: [ aBlock value: self ] tries: 40 ]
		  on: SpurCannotRead
		  do: [ :refusal |
			  refusal reason = #itWasNeverQuietWhenStopped ifFalse: [ refusal pass ].
			  self whileStoppedOutsideACollection: [ :dumped :stopped | aBlock value: stopped ] ]
