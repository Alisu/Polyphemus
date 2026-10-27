private
abandon: aChannel

	"A hold that failed while it was taken: its process put back if it was taken out, the agent
	ended and the reader closed, so the image goes on."

	[ aChannel ask: '(self at: #letGo ifAbsent: [ [  ] ]) value. nil' within: 5 seconds ]
		on: Error
		do: [ :error | nil ].
	aChannel letGoWithin: 5 seconds.
	reader close
