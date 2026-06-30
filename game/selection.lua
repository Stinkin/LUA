--------------------------------------------------
-- SELECTION
--
-- Pure runtime container that encapsulates volatile user selection
-- states and interactions with the board's slots.
--
-- Public API
--
-- Management
--   isSelected(slotId)
--   toggleSelection(slotId)
--   clearSelection()
--------------------------------------------------

local config = require("core.config")

local selection = {}

-- Array indexado que guarda los IDs de los slots elegidos
selection.current = nil

--------------------------------------------------
-- CLEAR SELECTION
-- Vacía por completo la lista de seleccionados.
--------------------------------------------------
function selection.clearSelection()

    selection.current = {}

end

--------------------------------------------------
-- IS SELECTED
--------------------------------------------------
function selection.isSelected(slotId)

    for _, selectedSlot in ipairs(selection.current) do
        if selectedSlot == slotId then
            return true
        end
    end

    return false

end

--------------------------------------------------
-- TOGGLE SELECTION
--------------------------------------------------
function selection.toggleSelection(slotId)

    -- Si ya existe, lo removemos (Deseleccionar)
    for i, selectedSlot in ipairs(selection.current) do
        if selectedSlot == slotId then
            table.remove(selection.current, i)
            return
        end
    end

    -- Si no existe, validamos el límite reglamentario antes de agregar
    if #selection.current >= config.MAX_SELECTION then
        return
    end

    table.insert(selection.current, slotId)

end

-- El archivo se auto-inicializa vacío al cargarse
selection.clearSelection()

return selection