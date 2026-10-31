saving
saved: aMessage

	"Saved, but not all of it: say what was done, outside the code, which the pane keeps as saved,
	in a message that stays until OK (#142)."

	told := aMessage.
	self ui alert: aMessage title: 'Saved, but not all of it'.
	^ true
