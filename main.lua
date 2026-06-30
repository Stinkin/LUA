local config = require("core.config")

-- 1. Importamos el corazón del juego (las instancias viven en game)
local game = require("game.game")
local gameplay = require("game.gameplay")
local selection = require("game.selection")

-- 2. Tus módulos visuales y de renderizado
local renderer = require("render.renderer")
local animations = require("render.animations")

--------------------------------------------------
-- LOAD
--------------------------------------------------
function love.load()

    love.window.setTitle("SET")

    love.window.setMode(
        config.WINDOW_WIDTH,
        config.WINDOW_HEIGHT
    )

    -- Inicializamos el juego (crea el mazo, lo mezcla y sirve el tablero)
    game.newGame()

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------
function love.update(dt)

    -- A) Avanzamos el reloj de tus animaciones cosméticas
    animations.update(dt)

    -- B) Si el usuario tiene 3 cartas seleccionadas, gameplay las procesa
    if #selection.current >= config.MAX_SELECTION then
        gameplay.resolveSelection(game.boardInstance, game.deckInstance, game.discardInstance)
    end

    -- C) Verificación de Game Over en cascada (pasándole el estado de tus animaciones)
    if gameplay.isGameOver(game.boardInstance, game.deckInstance, animations.isBusy()) then
        -- Aquí manejas tu estado final, pantalla de victoria/derrota, etc.
        print("Fin de la partida. No quedan más movimientos.")
    end

end

--------------------------------------------------
-- INPUT
--------------------------------------------------
function love.mousepressed(x, y, button)

    if button == 1 then -- Clic izquierdo
        -- Tu módulo renderer sabe exactamente dónde está dibujado cada slot en pantalla.
        -- Le pasamos las coordenadas x, y del mouse para que nos diga qué slotId pisó.
        local clickedSlot = renderer.getSlotAtCoordinates(x, y)
        
        if clickedSlot then
            selection.toggleSelection(clickedSlot)
        end
    end

end

function love.keypressed(key)

    -- Controles directos y cómodos para testear la arquitectura
    if key == "z" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")) then
        -- Deshacer en cascada definitivo
        gameplay.undo(game.boardInstance, game.deckInstance, game.discardInstance)
        
    elseif key == "h" then
        -- Pedir pista al solver
        gameplay.showHint(game.boardInstance)
        
    elseif key == "r" then
        -- Reiniciar partida completa
        game.newGame()
    end

end

--------------------------------------------------
-- DRAW
--------------------------------------------------
function love.draw()

    -- El renderer ahora recibe la instancia limpia del tablero para dibujarlo
    renderer.draw(game.boardInstance)

end