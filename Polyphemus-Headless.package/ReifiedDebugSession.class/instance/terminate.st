accessing
terminate

	"The window closed without Proceed: the image held is let go, as Proceed would have -- there is
	no process of ours to end (#116) -- and the stack read is forgotten, as Proceed does (#110)."

	self letTheImageGo.
	super terminate.
	self clear
