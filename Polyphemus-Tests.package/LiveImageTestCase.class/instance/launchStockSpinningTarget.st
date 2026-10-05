helpers
launchStockSpinningTarget

	"The pinned image spinning as the other targets do, but with no watcher of ours (#27)."

	^ self launchStockSpinningTargetLooping: '(1 to: 1000) do: [ :each | 3 sqrt ]'
