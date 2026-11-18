updating
forget

	"Done with: drop the memory read, its layout (the bytes read, a Cogit over them) and what was
	made of it, so that a context left over -- Pharo's debugger keeps one -- keeps nothing big (#110)."

	self forgetItsASTs.
	self forgetWhatWasRead.
	memory := objects := objectsArray := lastKnownObject := handlerCache := vmLayout := nil
