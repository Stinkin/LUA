--------------------------------------------------
-- CONSTANTS
--
-- Core mathematical axioms for the SET game logic.
-- Modifying these values alters the foundational nature of the game.
--------------------------------------------------

local constants = {}

-- Rules logic
constants.SET_SIZE = 3

-- Combinatorial math (3^4 = 81 Unique Cards)
constants.ATTRIBUTE_COUNT = 4
constants.ATTRIBUTE_VALUES = 3

constants.TOTAL_CARDS = constants.ATTRIBUTE_VALUES ^ constants.ATTRIBUTE_COUNT

return constants