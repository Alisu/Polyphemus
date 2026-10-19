asking
letGo

	"End the agent, and with it the hold: the image goes on."

	(self isServingBefore: DateAndTime now + 1 minute) ifFalse: [ ^ self ].
	self write: '' as: 'go'.
	self ring
