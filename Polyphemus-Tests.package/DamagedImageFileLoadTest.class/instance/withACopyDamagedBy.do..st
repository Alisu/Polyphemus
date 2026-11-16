damaging
withACopyDamagedBy: aDamage do: aBlock

	"aBlock's value with a copy of Candle holding that address -> word. Windows may not delete a
	copy the simulator still holds open: it is left."

	| copy |
	copy := DamagedCandleImage copyDamagedBy: { aDamage } readAs: clean.
	^ [ aBlock value: copy ] ensure: [ [ copy ensureDelete ] on: FileException do: [ :stillOpen | nil ] ]
