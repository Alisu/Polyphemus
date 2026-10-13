helpers
launchSleeper

	"A process of ours that is no Pharo VM; its pid."

	| pidFile |
	pidFile := PolyphemusEdition current scratch / 'mac-sleeper.pid'.
	pidFile ensureDelete.
	LibC system: 'sh -c ''sleep 30 >/dev/null 2>&1 & echo $! > "' , pidFile fullName , '"'''.
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	^ pidFile contents trimBoth asNumber
