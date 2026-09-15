private
readAt: anOffset count: aCount

	"Straight from the file. Near the end it answers what there is, which is fewer bytes than
	asked for; the callers above check what they are entitled to before asking."

	^ self stream
		  position: anOffset;
		  next: aCount
