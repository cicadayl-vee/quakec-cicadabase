# CicadaBase
A personal [fork of a fork](https://github.com/nashmuhandes/id1-quakec-cleaned) of a cleaned up 1.01 QuakeC codebase with several cherry picked changes and features from the 1.06, QuakeWorld, and Re-release QuakeC sources.

There is a whole heap of differences in this codebase but the most obivious one is that several things have been reorganized from the original sources. Weapon and item related stuff were chopped up into several different files instead of being all contained in one for easier editing (obituaries and blood were given their own seperate files), a lot of bugfixes like the [Re-release's Health Rot fix](https://github.com/id-Software/quake-rerelease-qc/blob/7bcbd29c9934e8523974263de50b3ae90b5d2605/quakec/client.qc#L1394) and [Matt's Rambling's thunderbolt fixes](https://www.youtube.com/watch?v=4gNYTqn3qRc), a lot of stupid little detail changes that bugged me, and probably a bunch of other things I've probably forgotten.

## Building
You'll need a QuakeC compiler like [FTEQCC](https://www.fteqcc.org/) to build CicadaBase.
