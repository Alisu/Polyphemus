accessing
terminate

	"The debugger's window closed without Proceed: the image held is let go, as Proceed would have
	-- there is no process of ours to end -- rather than left still with a core busy (#116)."

	self letTheImageGo.
	super terminate
