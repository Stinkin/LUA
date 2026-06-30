--------------------------------------------------
-- GAME
--
-- Core engine facade that encapsulates game state lifecycle,
-- initialization, and global match management (New Game, Restart).
--
-- Public API
--
-- Lifecycle
--   initialize()
--   newGame(seed)
--   restart()
--------------------------------------------------

local board = require("game.board")
local deck = require("game.deck")
local state = require("game.state")
local gameplay = require("game.gameplay")
local history = require("game.history")
local selection = require("game.selection")

local game = {}

-- Instancias físicas globales compartidas
game.boardInstance = nil
game.deckInstance = nil
game.discardInstance = nil

-- Persistencia de la semilla para el Restart
game.currentSeed = nil

--------------------------------------------------
-- INITIALIZE
-- Orquesta el arranque (Boot) físico de la aplicación.
--------------------------------------------------
function game.initialize()

    game.boardInstance = board.create()
    game.deckInstance = deck.create()
    game.discardInstance = deck.create()

    -- El motor arranca directo en una partida limpia por defecto
    game.newGame()

end

--------------------------------------------------
-- NEW GAME
-- Prepara las estructuras y el mazo desde cero.
--------------------------------------------------
function game.newGame(seed)

    game.currentSeed = seed

    -- 1. Reset de estados e historial globales
    history.clear()
    selection.clearSelection()

    -- 2. Limpieza e inicialización de los contenedores
    deck.initialize(game.deckInstance)
    deck.clear(game.discardInstance)
    board.clear(game.boardInstance)

    -- 3. Mezclado inicial del mazo
    deck.shuffle(game.deckInstance, game.currentSeed)

    -- 4. Servimos la mesa inicial reglamentaria
    gameplay.refill(game.boardInstance, game.deckInstance, game.discardInstance)

end

--------------------------------------------------
-- RESTART
-- Reinicia la misma partida exacta usando la semilla guardada.
--------------------------------------------------
function game.restart()

    game.newGame(game.currentSeed)

end

return game