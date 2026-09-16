checking
stopped: theFailuresSoFar

	^ theFailuresSoFar keys anySatisfy: [ :level |
		  self globalLevels includes: level ]
