where
selector

	^ (self request: '(self at: #session) interruptedContext selector asString') allButFirst allButLast
