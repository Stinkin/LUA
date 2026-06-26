local board = require("game.board")
local state = require("game.state")

local config = require("core.config")

local layout = require("render.layout")
local cards = require("render.cards")
local hud = require("render.hud")
local animations = require("render.animations")

local renderer = {}

--------------------------------------------------
-- DRAW
--------------------------------------------------

function renderer.draw(board)

    --------------------------------------------------
    -- BACKGROUND
    --------------------------------------------------

    love.graphics.clear(
        0.08,
        0.08,
        0.1
    )

    --------------------------------------------------
    -- BOARD
    --------------------------------------------------

    for slotId = 1,
        config.MAX_SLOTS
    do

        local card =
            board.getCard(slotId)

        if card then

            if not
                animations.isAnimating(
                    card
                )
            then

                local x, y =

                    layout.getSlotPosition(
                        slotId
                    )

                cards.draw(

                    card,

                    x,
                    y,

                   state.isSelected(
                        slotId
                    ),

                    false

                )

            end

        end

    end

    --------------------------------------------------
    -- ANIMATIONS
    --------------------------------------------------

    animations.draw()

    --------------------------------------------------
    -- HUD
    --------------------------------------------------

    hud.draw(board)

end

return renderer
