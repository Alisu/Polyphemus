tests
testAProcessStoppedThatCannotSayWhetherItIsQuietIsLetGo

	"#181: between the stop and the reading, asking whether it is quiet can fail (its state does
	not read): the process is let go before the refusal shows, not left stopped."

	| reader |
	reader := ProcessMemoryWhoseQuietDoesNotRead new.
	self should: [ reader whileStoppedWhenQuiet: [ nil ] tries: 1 ] raise: SpurCannotRead.
	self deny: reader isStopped
