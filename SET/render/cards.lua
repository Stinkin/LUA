local config = require("core.config")
local symbols = require("render.symbols")

local cards = {}

--------------------------------------------------
-- COLORS
--------------------------------------------------

local COLORS = {

    { 0.9, 0.2, 0.2 },
    { 0.2, 0.8, 0.2 },
    { 0.6, 0.2, 0.9 }

}

--------------------------------------------------
-- DRAW
--------------------------------------------------

function cards.draw(

    card,
    x,
    y,

    selected,
    hovered

)

    --------------------------------------------------
    -- CARD
    --------------------------------------------------

    if selected then

        love.graphics.setColor(
            config.CARD_SELECTED_COLOR
        )

    else

        love.graphics.setColor(
            config.CARD_BACKGROUND
        )

    end

    love.graphics.rectangle(

        "fill",

        x,
        y,

        config.CARD_WIDTH,
        config.CARD_HEIGHT,

        config.CARD_RADIUS,
        config.CARD_RADIUS

    )

    --------------------------------------------------
    -- BORDER
    --------------------------------------------------

    love.graphics.setColor(
        config.CARD_BORDER_COLOR
    )

    love.graphics.setLineWidth(
        config.CARD_BORDER
    )

    love.graphics.rectangle(

        "line",

        x,
        y,

        config.CARD_WIDTH,
        config.CARD_HEIGHT,

        config.CARD_RADIUS,
        config.CARD_RADIUS

    )

    --------------------------------------------------
    -- SYMBOLS
    --------------------------------------------------

    local count =
        card.count + 1

    local centerX =
        x +
        config.CARD_WIDTH / 2

    local centerY =
        y +
        config.CARD_HEIGHT / 2

    local totalHeight =

        (count - 1) *
        config.SYMBOL_SPACING

    local startY =

        centerY -
        totalHeight / 2

    local color =
        COLORS[
            card.color + 1
        ]

    for i = 1, count do

        local symbolY =

            startY +

            (i - 1) *
            config.SYMBOL_SPACING

        symbols.draw(

            card.shape,
            card.fill,

            centerX,
            symbolY,

            config.SYMBOL_WIDTH,
            config.SYMBOL_HEIGHT,

            color

        )

    end

end

return cards
