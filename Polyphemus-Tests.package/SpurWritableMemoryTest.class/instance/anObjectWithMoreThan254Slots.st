helpers
anObjectWithMoreThan254Slots

	"The class table's root sits a few objects into any heap and has thousands of slots."

	| scanner current |
	scanner := memory raw scanner.
	current := memory raw heapStart.
	20 timesRepeat: [
		(scanner slotsAt: current) > 254 ifTrue: [ ^ current ].
		current := scanner objectAfter: current ].
	^ nil
