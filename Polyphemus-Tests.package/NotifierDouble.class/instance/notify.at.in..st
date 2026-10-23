notifying
notify: aMessage at: aPosition in: aSource

	"As a code pane is told, which shows the message in the code at that position."

	self notices add: { aMessage. aPosition }.
	^ false
