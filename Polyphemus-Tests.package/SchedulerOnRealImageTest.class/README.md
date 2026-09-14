Stage one against a real image rather than the candle bootstrap.

Uses the pinned Pharo 10 snapshot, which carries the processes a working image has:
the idle process, timers, finalization, and whatever was waiting on a semaphore when
the image was written. Loading it costs some seconds, so this class lives in the slow
tier.
