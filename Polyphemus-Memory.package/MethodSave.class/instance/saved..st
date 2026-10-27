saving
saved: aMessage

	"Saved, but not all of it: say what was done, outside the code, which the pane keeps as saved."

	told := aMessage.
	UIManager default inform: aMessage.
	^ true
