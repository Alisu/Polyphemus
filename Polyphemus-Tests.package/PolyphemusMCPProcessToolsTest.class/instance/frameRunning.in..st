running
frameRunning: aMethodName in: aHandle

	"The first frame of any process running that method."

	(self processesOf: aHandle) do: [ :each |
		(self framesOf: aHandle process: (each at: 'process')) do: [ :frame |
			(frame at: 'method') = aMethodName ifTrue: [ ^ frame ] ] ].
	^ nil
