holding
giveUpTheHold

	"A hold that was asked for and not taken leaves nothing: no hold file for a signal still on its
	way to find (#137), the reader closed, the lock released (#181)."

	self forget: #( 'hold' ).
	[ reader close ] ensure: [ (HoldLock on: directory) release ]
