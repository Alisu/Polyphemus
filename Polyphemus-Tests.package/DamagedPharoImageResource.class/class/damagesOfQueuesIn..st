damages
damagesOfQueuesIn: aCleanReading

	"The first of the scheduler's lists, the one of the lowest priority, a tagged word (#118)."

	| lists |
	lists := aCleanReading processes reifiedScheduler reifiedSlotAt: aCleanReading processes processListsSlot.
	^ { ((DamagedCandleImage slot: 1 of: lists) -> self taggedWord) }
