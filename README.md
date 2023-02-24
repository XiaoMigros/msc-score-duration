# [Score Duration for MuseScore 3 & 4](https://musescore.org/en/project/score-duration)
A simple MuseScore plugin that tells you how long your score is.

## Features:
 - Output a score's run time in conventional time units
 - Save the values to Score Properties, with a variety of formats to choose from

## Changelog;
- 1.2.0: MuseScore 4 compatibility; Tag preview: The plugin shows how the Score Properties value will look; Massive code simplifications
- 1.1.2: Fixed a bug which meant settings only saved on 60s =< scores < 3600s; Fixed a bug where a score of eg. 61 seconds could be saved as 1:1 (preferred: 1:01); Text in the pop-up window doesn't automatically add plurals to all units; Text in the pop-up window won't display empty quotes if no score title was found; Various code simplifications
- 1.1.1: The plugin now saves selected options to settings.
- 1.1.0: The plugin can now write the duration to Score Properties, in a variety of formats.
- 1.0.1: Initial functional release

## Installation
Unzip the latest release and move 'Score Duration.qml' to MuseScore's plugins folder.

For more help installing this plugin, visit [this page](https://musescore.org/en/handbook/3/plugins#installation).
