asking
ringOrTakeBackTheRequest

	"Ring the agent for the request just written. A ring that fails leaves it unrung: the request is
	taken back, uncounted, or the next would be answered one behind and wait out its time (#181)."

	| rung |
	rung := false.
	[
	self ring.
	rung := true ] valueThenLetGo: [
		rung ifFalse: [
			(directory / ('request.' , count printString)) ensureDelete.
			count := count - 1 ] ]
