--------------------------------------------------
-- HUD
--
-- Heads-Up Display and Interface renderer. Manages standalone text
-- metrics, debug information, and interface buttons click collisions.
--
-- Public API
--   draw(board)
--   isAddThreePressed(mx, my)
--   isHintPressed(mx, my)
--------------------------------------------------

local config = require("core.config")
local state = require("game.state")

local hud = {}

--------------------------------------------------
-- PRIVATE METHODS
--------------------------------------------------

-- Centraliza las posiciones de los botones para evitar duplicar matemáticas
local function getButtonLayout(buttonIndex)

    local startY = config.HUD_Y + (config.HUD_LINE_HEIGHT * 8)
    local spacing = config.BUTTON_HEIGHT + 10

    local x = config.BUTTON_ADD3_X
    local y = startY + (buttonIndex - 1) * spacing

    return x, y, config.BUTTON_WIDTH, config.BUTTON_HEIGHT

end

local function drawButton(text, index)

    local x, y, width, height = getButtonLayout(index)

    -- Fondo del botón
    love.graphics.setColor(0.2, 0.2, 0.25, 1.0)
    love.graphics.rectangle("fill", x, y, width, height, 10, 10)

    -- Contorno
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.rectangle("line", x, y, width, height, 10, 10)

    -- Texto centrado
    love.graphics.printf(text, x, y + 14, width, "center")

end

local function isMouseInsideButton(index, mx, my)

    local x, y, width, height = getButtonLayout(index)

    local insideX = mx >= x and mx <= x + width
    local insideY = my >= y and my <= y + height

    return insideX and insideY

end

--------------------------------------------------
-- PUBLIC API
--------------------------------------------------

function hud.draw(board)

    local x = config.HUD_X
    local y = config.HUD_Y
    local line = config.HUD_LINE_HEIGHT

    --------------------------------------------------
    -- TEXT STATS
    --------------------------------------------------

    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)

    love.graphics.print("Cards Left: " .. #board.deck.cards, x, y)
    love.graphics.print("Selected: " .. #state.selected, x, y + line)
    love.graphics.print("Has Sets: " .. tostring(state.hasSets), x, y + line * 2)
    love.graphics.print("Deck Empty: " .. tostring(state.deckEmpty), x, y + line * 3)
    love.graphics.print("In Animation: " .. tostring(state.inAnimation), x, y + line * 4)
    love.graphics.print("Queued Animations: " .. tostring(#state.animation.queued), x, y + line * 5)
    love.graphics.print("Game Over: " .. tostring(state.gameOver), x, y + line * 6)

    --------------------------------------------------
    -- INTERFACE BUTTONS
    --------------------------------------------------

    drawButton("+3 Cards", 1)
    drawButton("Hint", 2)

end

function hud.isAddThreePressed(mx, my)
    return isMouseInsideButton(1, mx, my)
end

function hud.isHintPressed(mx, my)
    return isMouseInsideButton(2, mx, my)
end

return hud