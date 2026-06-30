--------------------------------------------------
-- CONTROLLER -- FINISHED
--
-- Translates raw hardware input events into semantic 
-- game actions via unified polymorphic element mapping.
--
-- Public API
--
-- Input Handlers
--   update(dt)
--   mousepressed(x, y, button)
--   keypressed(key)
--------------------------------------------------

local layout = require("render.layout")
local hud = require("render.hud")

local controller = {}

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function controller.update(dt)

end

--------------------------------------------------
-- MOUSE PRESSED
--------------------------------------------------

function controller.mousepressed(

    x,
    y,
    button

)

    if button ~= 1 then 
        return 
    end

    --------------------------------------------------
    -- UNIFIED INTERACTION
    --------------------------------------------------

    local element = 
        hud.getButtonAt(
            x,
            y
        ) or 
        layout.getSlotAtPosition(
            x,
            y
        )

    if element then
        element.pressed()
    end

end

--------------------------------------------------
-- KEY PRESSED
--------------------------------------------------

function controller.keypressed(key)
    -- Reservado para futuras implementaciones (Pausa, Undo, etc.)
end

return controller