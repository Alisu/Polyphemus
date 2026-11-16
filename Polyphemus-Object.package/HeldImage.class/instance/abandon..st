private
abandon: aChannel

	"A hold that failed while it was taken: its process put back if it was taken out, the agent
	ended and the reader closed, so the image goes on, whatever the asking raises."

	[
	[ aChannel ask: '(self at: #letGo ifAbsent: [ [  ] ]) value. nil' within: 5 seconds ]
		on: PolyphemusError
		do: [ :refusal | nil ] ] ensure: [
		[ aChannel letGoWithin: 5 seconds ] ensure: [
			[ reader close ] ensure: [ (HoldLock on: directory) release ] ] ]
