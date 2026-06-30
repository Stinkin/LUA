--------------------------------------------------
-- ANIMATIONS
--
-- Real-time animation pipeline using lightweight tweening.
-- Manages parallel translation animations for card entities.
--
-- Public API
--   moveCard(card, fromX, fromY, toX, toY, duration)
--   update(dt)
--   draw()
--   isAnimating(card)
--   isBusy()
--------------------------------------------------

local cards = require("render.cards")

local animations = {}

--------------------------------------------------
-- PRIVATE DATA
--------------------------------------------------

-- Lista que albergará todas las animaciones activas en paralelo
local activeTweens = {}

--------------------------------------------------
-- PUBLIC API
--------------------------------------------------

-- Registra una nueva animación de movimiento para una carta específica
function animations.moveCard(card, fromX, fromY, toX, toY, duration)
    
    local tween = {
        card = card,
        startX = fromX,
        startY = fromY,
        targetX = toX,
        targetY = toY,
        currentX = fromX,
        currentY = fromY,
        duration = duration or 0.3, -- 300ms por defecto si no se especifica
        elapsed = 0
    }
    
    table.insert(activeTweens, tween)
    
end

function animations.update(dt)

    -- Iteramos hacia atrás para poder remover elementos de la lista de forma segura
    for i = #activeTweens, 1, -1 do
        local tween = activeTweens[i]
        
        tween.elapsed = tween.elapsed + dt
        
        -- Calculamos el factor de progreso (normalizado entre 0.0 y 1.0)
        local progress = math.min(tween.elapsed / tween.duration, 1.0)
        
        -- Interpolación Lineal (Lerp) para suavizar el movimiento
        tween.currentX = tween.startX + (tween.targetX - tween.startX) * progress
        tween.currentY = tween.startY + (tween.targetY - tween.startY) * progress
        
        -- Si la animación terminó, la removemos del pipeline activo
        if progress >= 1.0 then
            table.remove(activeTweens, i)
        end
    end

end

function animations.draw()

    -- Dibujamos todas las cartas que se están moviendo actualmente
    for i = 1, #activeTweens do
        local tween = activeTweens[i]
        
        -- Invocamos al renderizador de cartas individuales pasándole su X e Y dinámicos
        cards.draw(
            tween.card, 
            tween.currentX, 
            tween.currentY, 
            false, -- No se dibuja seleccionada mientras vuela
            false  -- Estado por defecto
        )
    end

end

function animations.isAnimating(card)

    for i = 1, #activeTweens do
        if activeTweens[i].card == card then
            return true
        end
    end
    
    return false

end

function animations.isBusy()

    -- Retorna true si hay al menos una animación ejecutándose en pantalla
    return #activeTweens > 0

end

function animations.reset()

    activeTweens = {}

end

return animations