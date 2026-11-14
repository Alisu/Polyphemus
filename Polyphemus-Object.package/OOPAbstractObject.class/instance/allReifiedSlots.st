accessing-slots
allReifiedSlots

	"Each slot reified, in order; one that does not read stands as an OOPUnreadableSlot saying
	why, in its place, not as nil (#118)."

	^ (1 to: self oopNumberOfSlots) collect: [ :anIndex |
		  [ self reifiedSlotAt: anIndex ]
			  on: PolyphemusError
			  do: [ :e | OOPUnreadableSlot index: anIndex because: e messageText asString on: memory ] ]
