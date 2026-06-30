--------------------------------------------------
-- CONFIG
--
-- Static game configuration parameters, window dimensions, 
-- layout metrics, styling colors, and visual grid mappings.
--------------------------------------------------

local constants = require("core.constants")

local config = {}

config.game = constants

--------------------------------------------------
-- GAME RULES
--------------------------------------------------
config.MAX_SLOTS = 21
config.MIN_CARDS = 12
config.ADD_STEP = 3
config.MAX_SELECTION = 3

--------------------------------------------------
-- WINDOW
--------------------------------------------------
config.WINDOW_WIDTH = 1600
config.WINDOW_HEIGHT = 900

--------------------------------------------------
-- CARD SIZE & STYLE
--------------------------------------------------
config.CARD_WIDTH = 150
config.CARD_HEIGHT = 220
config.CARD_RADIUS = 16
config.CARD_BORDER = 4

--------------------------------------------------
-- CARD COLORS
--------------------------------------------------
config.CARD_BACKGROUND = { 1.0, 1.0, 1.0 }
config.CARD_BORDER_COLOR = { 0.15, 0.15, 0.15 }
config.CARD_SELECTED_COLOR = { 1.0, 0.8, 0.2 }

--------------------------------------------------
-- SYMBOL METRICS
--------------------------------------------------
config.SYMBOL_WIDTH = 80
config.SYMBOL_HEIGHT = 32
config.SYMBOL_SPACING = 48

--------------------------------------------------
-- BOARD SPACING & GRID
--------------------------------------------------
config.GAP_X = 24
config.GAP_Y = 24

config.VISUAL_COLUMNS = 7
config.VISUAL_ROWS = 3

--------------------------------------------------
-- HUD METRICS
--------------------------------------------------
config.HUD_WIDTH = 260
config.HUD_X = config.WINDOW_WIDTH - config.HUD_WIDTH + 20
config.HUD_Y = 80
config.HUD_LINE_HEIGHT = 30

--------------------------------------------------
-- DYNAMIC BOARD POSITIONING
--------------------------------------------------
local boardWidth = (config.VISUAL_COLUMNS * config.CARD_WIDTH) + ((config.VISUAL_COLUMNS - 1) * config.GAP_X)
local usableWidth = config.WINDOW_WIDTH - config.HUD_WIDTH

config.BOARD_OFFSET_X = (usableWidth - boardWidth) / 2
config.BOARD_OFFSET_Y = 80

--------------------------------------------------
-- SLOT VISUAL GRID MAP
-- Maps 1D linear indexes (1-21) to spatial matrix slots.
--------------------------------------------------
config.SLOT_VISUAL_MAP = {
    19, 13, 1, 4, 7, 10, 16,
    20, 14, 2, 5, 8, 11, 17,
    21, 15, 3, 6, 9, 12, 18
}

--------------------------------------------------
-- ANIMATION
--------------------------------------------------
config.ANIMATION_SPEED = 8

--------------------------------------------------
-- INTERFACE BUTTONS
--------------------------------------------------
config.BUTTON_WIDTH = 180
config.BUTTON_HEIGHT = 48
config.BUTTON_ADD3_X = config.HUD_X
config.BUTTON_ADD3_Y = config.HUD_Y + 120

return config