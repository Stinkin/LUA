--------------------------------------------------
-- GAMEPLAY
--
-- Orchestrates game rules, state mutations, and coordination
-- between the board, physical decks, state, history, and solvers.
--
-- Public API
--
-- Operations
--   resolveSelection(board, deckInstance, discardInstance)
--   refill(board, deckInstance, discardInstance)
--   undo(board, deckInstance, discardInstance)
--   showHint(board)
--   isGameOver(board, deckInstance, isRendererBusy)
-- 
--------------------------------------------------

local state = require("game.state")
local deck = require("game.deck")
local boardModule = require("game.board") -- Cambiado de nombre local para evitar colisión con el parámetro
local setlogic = require("game.setlogic")
local solver = require("game.solver")
local history = require("game.history")

local gameplay = {}

--------------------------------------------------
-- RESOLVE SELECTION
-- Evalúa las 3 cartas seleccionadas. Si forman un Set,
-- las remueve del tablero y las deposita en el descarte.
--------------------------------------------------
function gameplay.resolveSelection(board, deckInstance, discardInstance)

    if #state.selected < 3 then
        return
    end

    local slotA = state.selected[1]
    local slotB = state.selected[2]
    local slotC = state.selected[3]

    local cardA = boardModule.getCard(board, slotA)
    local cardB = boardModule.getCard(board, slotB)
    local cardC = boardModule.getCard(board, slotC)

    --------------------------------------------------
    -- VALID SET EVALUATION
    --------------------------------------------------
    if setlogic.isSet(cardA, cardB, cardC) then

        -- Las removemos físicamente del tablero
        local removedA = boardModule.removeCard(board, slotA)
        local removedB = boardModule.removeCard(board, slotB)
        local removedC = boardModule.removeCard(board, slotC)

        --------------------------------------------------
        -- DEPOSIT TO DISCARD PILE
        --------------------------------------------------
        deck.push(discardInstance, removedA)
        deck.push(discardInstance, removedB)
        deck.push(discardInstance, removedC)

        --------------------------------------------------
        -- RECORD MATCH TO HISTORY
        --------------------------------------------------
        history.push({
            type = "match",
            slots = { slotA, slotB, slotC },
            cards = { removedA, removedB, removedC }
        })

        -- Auto-relleno reglamentario post-match
        gameplay.refill(board, deckInstance, discardInstance)
    end

    --------------------------------------------------
    -- CLEAR SELECTION
    --------------------------------------------------
    state.clearSelection()

end

--------------------------------------------------
-- REFILL
-- Detecta huecos vacíos en el tablero y los rellena
-- robando cartas del mazo principal.
--------------------------------------------------
function gameplay.refill(board, deckInstance, discardInstance)

    local placedChanges = {}

    -- Buscamos los slots vacíos en el tablero actual
    -- Nota: Asumimos que boardModule expone una forma de saber sus slots vacíos o iteramos sus límites fijos
    for slotIndex = 1, #board.slots do
        if boardModule.isSlotEmpty(board, slotIndex) then
            
            -- Si el mazo se vacía, intentamos reciclar el descarte
            if deck.isEmpty(deckInstance) then
                if not deck.isEmpty(discardInstance) then
                    -- Pasamos el descarte al mazo principal y mezclamos
                    -- Nota: la semilla para re-mezclar en mitad de partida puede ser nil o una derivada
                    deck.shuffleInto(discardInstance, deckInstance) 
                end
            end

            -- Si logramos tener cartas, robamos una y la ponemos en el tablero
            if not deck.isEmpty(deckInstance) then
                local card = deck.pop(deckInstance)
                boardModule.setCard(board, slotIndex, card)
                
                table.insert(placedChanges, {
                    slot = slotIndex,
                    card = card
                })
            end
        end
    end

    if #placedChanges == 0 then
        return
    end

    --------------------------------------------------
    -- RECORD REFILL TO HISTORY
    --------------------------------------------------
    history.push({
        type = "refill",
        placed = placedChanges
    })

end

--------------------------------------------------
-- UNDO
-- Saca los eventos en cascada del historial y revierte sus efectos físicos.
-- Primero devuelve las cartas compactadas y luego restaura el Match o Refill.
--------------------------------------------------
function gameplay.undo(board, deckInstance, discardInstance)

    -- 1. Limpiamos la selección actual para evitar inconsistencias visuales
    state.clearSelection()

    -- 2. Bucle en cascada: Deshacemos cualquier movimiento cosmético primero.
    -- Miramos la cima del historial sin extraerla todavía (history.peek).
    local nextEvent = history.peek()

    while nextEvent and nextEvent.type == "compact" do
        -- Ahora sí lo extraemos oficialmente
        local compactEvent = history.pop()
        
        -- Revertimos los desplazamientos en orden INVERSO (del último al primero)
        -- para regresar las cartas a sus baches originales de forma segura.
        for i = #compactEvent.moves, 1, -1 do
            local move = compactEvent.moves[i]
            boardModule.moveCard(board, move.to, move.from)
        end
        
        -- Volvemos a mirar la cima para ver si hay más compactaciones
        nextEvent = history.peek()
    end

    -- 3. Una vez despejada la mesa de compactaciones, sacamos el evento estructural base
    local baseEvent = history.pop()
    if not baseEvent then
        return -- Si no hay evento base, salimos pacíficamente
    end

    --------------------------------------------------
    -- REVERT STRUCTURAL EVENT
    --------------------------------------------------
    if baseEvent.type == "match" then
        -- Sacamos las últimas 3 cartas del descarte usando la API real (deck.draw)
        local cardC = deck.draw(discardInstance)
        local cardB = deck.draw(discardInstance)
        local cardA = deck.draw(discardInstance)

        -- Ahora que el tablero fue des-compactado en el paso anterior,
        -- los slots originales están perfectamente vacíos esperando sus cartas.
        boardModule.setCard(board, baseEvent.slots[1], cardA)
        boardModule.setCard(board, baseEvent.slots[2], cardB)
        boardModule.setCard(board, baseEvent.slots[3], cardC)

    elseif baseEvent.type == "refill" then
        -- Deshacer un refill: removemos las cartas servidas y las regresamos al mazo
        for i = #baseEvent.placed, 1, -1 do
            local change = baseEvent.placed[i]
            boardModule.removeCard(board, change.slot)
            deck.add(deckInstance, change.card) -- Usando la API real (deck.add)
        end
    end

end

--------------------------------------------------
-- SHOW HINT
-- Usa el solver para buscar combinaciones válidas en la mesa.
--------------------------------------------------
function gameplay.showHint(board)

    local foundSet = solver.getFirstSet(board.slots)

    if not foundSet then
        return
    end

    state.clearSelection()
    
    -- Seleccionamos automáticamente los slots del set encontrado para asistir al jugador
    state.toggleSelection(foundSet[1])
    state.toggleSelection(foundSet[2])


end

--------------------------------------------------
-- IS GAME OVER
-- Consulta pura que determina si la partida actual ha concluido.
-- Combina la lógica del mazo, el solver y el estado gráfico.
--------------------------------------------------
function gameplay.isGameOver(board, deckInstance, isRendererBusy)

    -- 1. Si el mazo todavía tiene cartas, el juego sigue activo
    if not deck.isEmpty(deckInstance) then
        return false
    end

    -- 2. Si el motor gráfico todavía está moviendo cartas en pantalla,
    -- esperamos a que terminen de acomodarse antes de cerrar el juego
    if isRendererBusy then
        return false
    end

    -- 3. Si el mazo está vacío y no hay animaciones pendientes,
    -- el solver tiene la última palabra buscando un Set válido en la mesa
    local foundSet = solver.getFirstSet(board.slots)
    if not foundSet then
        return true -- No hay mazo, no hay animaciones y no hay Sets = GAME OVER
    end

    return false
end

return gameplay