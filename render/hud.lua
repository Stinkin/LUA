local config =
    require("core.config")

local state =
    require("game.state")

local hud = {}

--------------------------------------------------
-- BUTTON
--------------------------------------------------

local function drawButton(

    text,

    x,
    y,

    width,
    height

)

    love.graphics.setColor(
        0.2,
        0.2,
        0.25
    )

    love.graphics.rectangle(

        "fill",

        x,
        y,

        width,
        height,

        10,
        10

    )

    love.graphics.setColor(
        1,
        1,
        1
    )

    love.graphics.rectangle(

        "line",

        x,
        y,

        width,
        height,

        10,
        10

    )

    love.graphics.printf(

        text,

        x,
        y + 14,

        width,

        "center"

    )

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function hud.draw(board)

    local x =
        config.HUD_X

    local y =
        config.HUD_Y

    local line =
        config.HUD_LINE_HEIGHT

    --------------------------------------------------
    -- TEXT
    --------------------------------------------------

    love.graphics.setColor(
        1,
        1,
        1
    )

    love.graphics.print(

        "Cards Left: " ..

        #board.deck.cards,

        x,
        y

    )

    love.graphics.print(

        "Selected: " ..

        #state.selected,

        x,
        y + line

    )

    love.graphics.print(

        "Has Sets: " ..

        tostring(
            state.hasSets
        ),

        x,
        y + line * 2

    )

    love.graphics.print(

        "Deck Empty: " ..

        tostring(
            state.deckEmpty
        ),

        x,
        y + line * 3

    )

    love.graphics.print(

        "In Animation: " ..

        tostring(
            state.inAnimation
        ),

        x,
        y + line * 4

    )

    love.graphics.print(

        "Queued Animations: " ..

        tostring(
            #state.animation.queued
        ),

        x,
        y + line * 5

    )

    love.graphics.print(

        "Game Over: " ..

        tostring(
            state.gameOver
        ),

        x,
        y + line * 6

    )

    --------------------------------------------------
    -- BUTTON LAYOUT
    --------------------------------------------------

    local buttonY =

        y +
        line * 8

    --------------------------------------------------
    -- BUTTONS
    --------------------------------------------------

    drawButton(

        "+3 Cards",

        config.BUTTON_ADD3_X,
        buttonY,

        config.BUTTON_WIDTH,
        config.BUTTON_HEIGHT

    )

    drawButton(

        "Hint",

        config.BUTTON_ADD3_X,
        buttonY +
        config.BUTTON_HEIGHT +
        10,

        config.BUTTON_WIDTH,
        config.BUTTON_HEIGHT

    )

end

--------------------------------------------------
-- INPUT
--------------------------------------------------

function hud.isAddThreePressed(mx, my)

    local buttonY =

        config.HUD_Y +
        config.HUD_LINE_HEIGHT * 8

    local insideX =

        mx >= config.BUTTON_ADD3_X and

        mx <=

        config.BUTTON_ADD3_X +
        config.BUTTON_WIDTH

    local insideY =

        my >= buttonY and

        my <=

        buttonY +
        config.BUTTON_HEIGHT

    return
        insideX and insideY

end

function hud.isHintPressed(mx, my)

    local buttonY =

        config.HUD_Y +
        config.HUD_LINE_HEIGHT * 8 +
        config.BUTTON_HEIGHT +
        10

    local insideX =

        mx >= config.BUTTON_ADD3_X and

        mx <=

        config.BUTTON_ADD3_X +
        config.BUTTON_WIDTH

    local insideY =

        my >= buttonY and

        my <=

        buttonY +
        config.BUTTON_HEIGHT

    return
        insideX and insideY

end

return hud