stepping
stepOver

	channel ask: '(self at: #session) stepOver: (self at: #session) interruptedContext. nil'
