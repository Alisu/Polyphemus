holding
letGo

	"The image goes on, and we let go of it and of what we read of it, though letting go failed.
	No hold is wanted any more: a signal still on its way finds no hold file (#137)."

	self forget: #( 'hold' 'trap' ).
	[ process letGo ] ensure: [
		reader close.
		process forgetTheReading ]
