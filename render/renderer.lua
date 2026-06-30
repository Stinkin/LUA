--------------------------------------------------
-- RENDERER
--
-- High-level render orchestrator. Clears the frame buffer, 
-- sequences static cards, active animations, and the HUD.
--
-- Public API
--   draw(boardInstance)
--------------------------------------------------

local config = require("core.config")
local layout = require("render.layout")
local cards = require("render.cards")
local hud = require("render.hud")
local animations = require("render.animations")

-- Nota: Eliminamos los 'require' globales de game.board y game.state 
-- para que el renderizador sea puramente pasivo y reciba los datos por inyección.

local renderer = {}

--------------------------------------------------
-- PUBLIC API
--------------------------------------------------

function renderer.draw(boardInstance)

    --------------------------------------------------
    -- BACKGROUND
    --------------------------------------------------

    love.graphics.clear(0.08, 0.08, 0.1)

    --------------------------------------------------
    -- BOARD CARDS
    --------------------------------------------------

    for slotId = 1, config.MAX_SLOTS do
        local card = boardInstance.getCard(slotId)

        if card then
            -- Si la carta está en medio de una transición visual, 
            -- el sistema de animación toma total control de su renderizado.
            if not animations.isAnimating(card) then
                local x, y = layout.getSlotPosition(slotId)
                
                -- Le preguntamos directamente a la instancia de board si el slot está seleccionado
                local isSelected = boardInstance.isSelected and boardInstance.isSelected(slotId)

                cards.draw(card, x, y, isSelected, false)
            end
        end
    end

    --------------------------------------------------
    -- ANIMATION PIPELINE
    --------------------------------------------------

    animations.draw()

    --------------------------------------------------
    -- HUD / INTERFACE
    --------------------------------------------------

    hud.draw(boardInstance)

end

return renderer