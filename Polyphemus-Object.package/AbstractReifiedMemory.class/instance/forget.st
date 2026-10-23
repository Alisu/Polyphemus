updating
forget

	"Done with: drop the memory read and what was made of it, so that a context left over -- Pharo's
	debugger keeps one -- keeps nothing big (#110)."

	self forgetItsASTs.
	self forgetWhatWasRead.
	memory := objects := objectsArray := lastKnownObject := handlerCache := nil
