asking
ask: aSource

	"What the image answers for that source, evaluated where `self at: #process` is the process
	and `self at: #session` its debug session there."

	^ channel ask: aSource
