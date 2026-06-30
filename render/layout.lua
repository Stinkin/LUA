--------------------------------------------------
-- LAYOUT
--
-- Spatial layout manager. Pre-calculates pixel coordinates 
-- for board slots using a configuration visual map matrix.
--
-- Public API
--   getSlotPosition(slotId)
--   getSlotAtPosition(mx, my)
--------------------------------------------------

local config = require("core.config")

local layout = {}

--------------------------------------------------
-- PRIVATE DATA & METHODS
--------------------------------------------------

-- Tabla local (privada) para almacenar las coordenadas calculadas
local slotPositions = {}

local function build()

    local visualIndex = 1

    for row = 1, config.VISUAL_ROWS do
        for column = 1, config.VISUAL_COLUMNS do

            local slotId = config.SLOT_VISUAL_MAP[visualIndex]

            -- Si el mapa visual tiene asignado un ID válido para este casillero
            if slotId then
                local x = config.BOARD_OFFSET_X + (column - 1) * (config.CARD_WIDTH + config.GAP_X)
                local y = config.BOARD_OFFSET_Y + (row - 1) * (config.CARD_HEIGHT + config.GAP_Y)

                slotPositions[slotId] = {
                    x = x,
                    y = y
                }
            end

            visualIndex = visualIndex + 1
        end
    end

end

-- Ejecutamos la construcción privada al cargar el módulo por primera vez
build()

--------------------------------------------------
-- PUBLIC API
--------------------------------------------------

function layout.getSlotPosition(slotId)

    local position = slotPositions[slotId]

    if not position then
        return 0, 0
    end

    return position.x, position.y

end

function layout.getSlotAtPosition(mx, my)

    for slotId, position in pairs(slotPositions) do

        local insideX = mx >= position.x and mx <= position.x + config.CARD_WIDTH
        local insideY = my >= position.y and my <= position.y + config.CARD_HEIGHT

        if insideX and insideY then
            return slotId
        end
    end

    return nil

end

return layout