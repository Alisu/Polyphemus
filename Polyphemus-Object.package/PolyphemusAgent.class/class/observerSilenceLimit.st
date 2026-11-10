accessing
observerSilenceLimit

	"How long an agent hears nothing from its observer's heartbeat before letting the image go
	(#163): a dead observer no longer holds it to the hold limit."

	^ ObserverSilenceLimit ifNil: [ 30 seconds ]
