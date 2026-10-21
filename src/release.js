/**
 * Which release this is: the date of the newest entry in RELEASES.txt,
 * shown at the right of the menu bar. Change the two together, as the last
 * step of a release (the public site publishes the `release` branch).
 * A constant rather than read from RELEASES.txt because a page opened from
 * disk (file://) may not read files.
 */
window.SIMILE_RELEASE = '2026-10-21';
