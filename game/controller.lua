local board = require("game.board")
local state = require("game.state")
local gameplay = require("game.gameplay")

local layout = require("render.layout")
local hud = require("render.hud")

local controller = {}

function controller.update(dt)

end

function controller.mousepressed(

    x,
    y,
    button

)

    if state.isAnimating() 
    then
        return
    end

    if button ~= 1 then
        return
    end

    --------------------------------------------------
    -- ADD THREE
    --------------------------------------------------

    if hud.isAddThreePressed(
        x,
        y
    ) then

        gameplay.refill(board)

        return

    end

    --------------------------------------------------
    -- HINT
    --------------------------------------------------

    if hud.isHintPressed(
        x,
        y
    ) then

        gameplay.showHint(board)

        return

    end

    local slotId =

        layout.getSlotAtPosition(
            x,
            y
        )

    if not slotId then
        return
    end

    local card =
        board.getCard(slotId)

    if not card then
        return
    end

    state.toggleSelection(
        slotId
    )
    gameplay.resolveSelection(board)
end

function controller.keypressed(key)

end

return controller
