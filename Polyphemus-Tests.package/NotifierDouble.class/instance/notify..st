notifying
notify: aMessage

	"As anything is told: a code pane does not show it, a Warning is raised (#108)."

	self notices add: { aMessage. nil }.
	^ false
