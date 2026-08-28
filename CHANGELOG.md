# Changelog

## [2.0.4] - 2026-08-28

- Added native dismantling support for structural and multi-tile objects.
- Fixed material recovery, duplicate salvage callbacks, and floor restoration.
- Improved placement validation by ignoring ground inventory objects.
- Added construction definitions, recipes, translations, and API documentation updates.
- Added stackable fence behavior and expanded outdoor/military construction support.

## [2.0.3] - 2026-08-25

- Added native barricade support for ordinary single doors.
- Extracted the virtual building list into a reusable UI component.
- Implemented complete gamepad navigation and interaction for the building interface.
- Removed obsolete and redundant code from the construction UI.

## [2.0.2] - 2026-08-24

- Added target-location material validation to prevent timed actions from completing when materials are no longer accessible.
- Added construction failure feedback for unavailable materials.
- Initialized recipe-defined construction and completion sounds before ISBuildAction starts.
- Refactored multi-tile furniture to instantiate each sprite component according to its native properties.
- Fixed multi-tile container creation and collision behavior.
- Added support for colored light bulbs and synchronized per-bulb light colors.
- Fixed missing localization for light context menus in multiplayer.
- Added material-choice tooltips alongside tool-choice tooltips.
- Updated door-frame behavior to avoid inappropriate thumpable handling.
- Added entity construction validation guards for client actions.

## [2.0.1] - 2026-08-22

- Added native entity-script building support.
- Extended placement validation, construction flow, previews, material handling, dismantling, and world-object creation.
- Added military barrels, training targets, military signs, and an electric chair.
- Changed industry_01_22 from a container to ordinary furniture.
- Updated the API documentation.

## [2.0.0] - 2026-08-13

- Completely rebuilt for Project Zomboid Build 42; Build 41 is no longer supported.
- Added a large selection of buildable vanilla furniture, appliances, lights,
  decorations, doors, windows, walls, floors, fences, and outdoor objects.
- Reworked the build menu with search, clearer categories, favourites, tooltips,
  and a configurable `Ctrl+B` shortcut.
- Updated material, tool, and skill requirements; dismantling returns the
  materials used to build eligible More Builds objects.
- Improved placement validation, rotation, multi-tile objects, wall-mounted
  objects, containers, lights, generators, water sources, and moveable support.
- Added multiplayer build permissions, server-synchronised Popular Buildings,
  and expanded sandbox options for water sources and popular-building lists.

## [1.2.0] - 2025-01-26

- Compatible with B42.

## [1.1.9] - 2023-02-04

- Fixed plastered windowed walls.
- Fixed garage doors not working in some cases.
- Fixed double water consumption.
- Added Brazilian Portuguese translation by Lordben-wan.
- Adjusted material consumption for high metal fences.

## [1.1.8a] - 2022-05-27

- Added another military crate direction selectable with `R`.
- Adjusted material and skill requirements for metal signs.
- Added Korean translation.
- Added `Base.Shovel2` to accepted shovel tools.

## [1.1.8] - 2022-05-26

- Fixed log pillars not being visible after construction.
- Fixed rubber floors losing collision after reload.
- Added Moveable properties to rubber floors.
- Fixed military crate stacking.
- Set military crate capacity to 100 and Carpentry requirement to 6.
- Converted Traditional Chinese translation from Big5 to UTF-8.

## [1.1.7] - 2022-05-14

- Added Spanish translation.
- Added multiplayer build-permission settings.
- Added water-well capacity setting.
- Added glass doors.

## [1.1.6] - 2022-02-25

- Removed unused debug modules.
- Added Traditional Chinese and Russian translations.
- Updated skill requirements.
- Added experimental sandbox settings.

## [1.1.5] - 2022-02-08

- Reworked the base code.
- Added backpack and ground-material support.
- Reworked multi-tool and skill requirement handling.
- Fixed barbecue construction.

## [1.0.0] - 2015-09-10

- Initial release.
