helpers
launchASleeper

	^ (LibC resultOfCommand: 'sleep 600 > /dev/null 2>&1 & echo $!') trimBoth asNumber
