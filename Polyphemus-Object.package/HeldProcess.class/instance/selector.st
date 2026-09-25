where
selector

	^ (channel ask: '(self at: #session) interruptedContext selector asString') allButFirst allButLast
