private
noteAHold

	"Whether this hold finds its process ended."

	holds := holds + 1.
	^ holds <= endings
