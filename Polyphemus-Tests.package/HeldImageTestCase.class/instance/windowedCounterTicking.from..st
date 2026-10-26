targets
windowedCounterTicking: aTickSource from: aStart

	"As counterTicking:from:after:, showing n in a window of its own."

	^ 'cls compile: ' , aTickSource printString , '.
[ | n label | n := ' , aStart printString , '.
  label := StringMorph contents: ''0''.
  (label openInWindowLabeled: ''Counter'') extent: 360 @ 160.
  [ n := cls new tick: n. label contents: n printString. (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
'
