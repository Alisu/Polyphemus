holding
armTheTrapUntil: aMethodSource

	"A trap put in the held image before that method, wanted for as long as its file is there: a
	process that reaches it once the file is gone takes the trap out and runs on (#181)."

	self forget: #( 'trap' 'interrupted' 'released' 'hold' ).
	(directory / 'trap-wanted') ensureCreateFile.
	process ask: (PolyphemusAgent trapSourceFor: aMethodSource in: directory signalling: self semaphoreIndex)
