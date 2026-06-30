--------------------------------------------------
-- CARDS
--
-- Mid-level renderer responsible for drawing the physical card
-- container and distributing its inner symbols based on layout properties.
--
-- Public API
--   draw(card, x, y, selected, hovered)
--------------------------------------------------

local config = require("core.config")
local symbols = require("render.symbols")

local cards = {}

--------------------------------------------------
-- PRIVATE CONSTANTS
--------------------------------------------------

local COLORS = {
    { 0.9, 0.2, 0.2 }, -- Red
    { 0.2, 0.8, 0.2 }, -- Green
    { 0.6, 0.2, 0.9 }  -- Purple
}

--------------------------------------------------
-- PRIVATE METHODS (Locales)
--------------------------------------------------

local function drawCardBody(x, y, selected, hovered)

    -- Base de la carta
    if selected then
        love.graphics.setColor(config.CARD_SELECTED_COLOR)
    else
        love.graphics.setColor(config.CARD_BACKGROUND)
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

    -- Contorno / Borde
    love.graphics.setColor(config.CARD_BORDER_COLOR)
    love.graphics.setLineWidth(config.CARD_BORDER)

    love.graphics.rectangle(
        "line",
        x,
        y,
        config.CARD_WIDTH,
        config.CARD_HEIGHT,
        config.CARD_RADIUS,
        config.CARD_RADIUS
    )

end

local function drawCardSymbols(card, x, y)

    local count = card.count + 1
    local centerX = x + config.CARD_WIDTH / 2
    local centerY = y + config.CARD_HEIGHT / 2

    local totalHeight = (count - 1) * config.SYMBOL_SPACING
    local startY = centerY - totalHeight / 2
    local color = COLORS[card.color + 1]

    for i = 1, count do
        local symbolY = startY + (i - 1) * config.SYMBOL_SPACING

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

--------------------------------------------------
-- PUBLIC API
--------------------------------------------------

function cards.draw(
    card,
    x,
    y,
    selected,
    hovered
)

    -- 1. Renderizar el contenedor físico (base y bordes)
    drawCardBody(x, y, selected, hovered)

    -- 2. Calcular posiciones de símbolos y mandarlos a dibujar
    drawCardSymbols(card, x, y)

end

return cards