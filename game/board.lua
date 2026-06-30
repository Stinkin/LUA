--------------------------------------------------
-- BOARD -- FINISHED
--
-- Owns the game board and preserves its invariants.
--
-- Public API
--
-- Lifecycle
--   initialize()
--   clear()
--
-- Queries
--   getCard(slot)
--   getCardCount()
--   isFull()
--   getFirstEmptySlot()
--   getLastOccupiedSlot()
--
-- Commands
--   placeCard(slot, card)
--   removeCard(slot)
--   moveCard(from, to)
--   compact()
--------------------------------------------------

local deck = require("game.deck")
local state = require("game.state")
local discard = require("game.discard")

local config = require("core.config")

local board = {}

--------------------------------------------------
-- STATE
--------------------------------------------------

board.deck = nil

board.slots = {}

--------------------------------------------------
-- IS_VALID ** PRIVATE FUNCTION **
--------------------------------------------------
local function isValidSlot(slot)
    return slot >= 1 and slot <= config.MAX_SLOTS
end

--------------------------------------------------
-- SLOT_IS_EMPTY ** PRIVATE FUNCTION **
--------------------------------------------------
local function slotIsEmpty(slot)
    return board.slots[slot] == false
end

--------------------------------------------------
-- INITIALIZE
--------------------------------------------------
function board.initialize()
    board.clear()
end

--------------------------------------------------
-- CLEAR
--------------------------------------------------
function board.clear()
    for i = 1, config.MAX_SLOTS do
        board.slots[i] = false
    end
end

--------------------------------------------------
-- GET_CARD
--------------------------------------------------
function board.getCard(slot)
    assert(isValidSlot(slot))
    if slotIsEmpty(slot) then
        return nil
    end
    return board.slots[slot]
end

--------------------------------------------------
-- GET_CARD_COUNT
--------------------------------------------------
function board.getCardCount()
    local count = 0
    for i = 1, config.MAX_SLOTS do 
        if board.slots[i] then 
            count=count+1
        end
    end
    return count
end


--------------------------------------------------
-- IS_FULL
--------------------------------------------------
function board.isFull()
    return board.getCardCount() == config.MAX_SLOTS
end

--------------------------------------------------
-- GET_FIRST_EMPTY_SLOT
--------------------------------------------------
function board.getFirstEmptySlot()
    for i=1, config.MAX_SLOTS do 
        if slotIsEmpty(i) then
            return i
        end
    end
    return nil
end

--------------------------------------------------
-- GET_LAST_OCCUPIED_SLOT
--------------------------------------------------
function board.getLastOccupiedSlot()
    for i= config.MAX_SLOTS, 1, -1 do 
        if not slotIsEmpty(i) then
            return i
        end
    end
    return nil
end



--------------------------------------------------
-- PLACE_CARD
--------------------------------------------------
function board.placeCard(slot, card)
    assert(isValidSlot(slot))
    assert(card ~= nil)
    assert(slotIsEmpty(slot))
    board.slots[slot] = card
end

--------------------------------------------------
-- REMOVE_CARD
--------------------------------------------------
function board.removeCard(slot)
    assert(isValidSlot(slot))
    assert(not slotIsEmpty(slot))
    local card = board.getCard(slot)
    board.slots[slot] = false
    return card
end

--------------------------------------------------
-- MOVE_CARD
--------------------------------------------------
function board.moveCard(from, to)
    assert(isValidSlot(from))
    assert(isValidSlot(to))
    assert(not slotIsEmpty(from))
    assert(slotIsEmpty(to))
    local card = board.removeCard(from)
    board.placeCard(to, card)
end 

--------------------------------------------------
-- COMPACT
--------------------------------------------------
--------------------------------------------------
-- COMPACT (Optimizado)
-- Agrupa todos los movimientos de la compactación en un solo evento de historial
--------------------------------------------------
function board.compact(self)
    local movesReported = {}

    while true do
        local firstEmpty = board.getFirstEmptySlot(self)
        local lastOccupied = board.getLastOccupiedSlot(self)
        
        if not firstEmpty or not lastOccupied or lastOccupied < firstEmpty then
            break
        end

        -- Guardamos el viaje de esta carta específica
        table.insert(movesReported, {
            from = lastOccupied,
            to = firstEmpty,
            card = board.getCard(self, lastOccupied)
        })

        board.moveCard(self, lastOccupied, firstEmpty)
    end

    -- Si se movió al menos una carta, mandamos un único reporte al historial
    if #movesReported > 0 then
        history.push({
            type = "compact",
            moves = movesReported
        })
    end
end

return board
--------------------------------------------------
--------------------------------------------------
-- OLD CODE
--------------------------------------------------
--------------------------------------------------


function board.initializeOLD()

    local seed =
        os.time()

    math.randomseed(seed)

    state.seed = seed

    state.reset()

    discard.create()
    
    board.deck =
        deck.create()

    deck.shuffle(board.deck)

    for i = 1,
        config.MAX_SLOTS
    do

        board.slots[i] = nil

    end

    --------------------------------------------------
    -- INITIAL CARDS
    --------------------------------------------------

    for i = 1,
        config.MIN_CARDS
    do

        board.addCard()

    end

    state.update(board)

end

--------------------------------------------------
-- CARD COUNT
--------------------------------------------------

function board.getCardCount()

    local count = 0

    for i = 1,
        config.MAX_SLOTS
    do

        if board.slots[i]
        ~= nil
        then

            count = count + 1

        end

    end

    return count

end

--------------------------------------------------
-- ADD CARD
--------------------------------------------------

function board.addCard()

    for i = 1, config.MAX_SLOTS do

        if board.slots[i] == nil then

            local card = deck.draw(board.deck)

            if card == nil then
                return false
            end

            board.slots[i] = card

            return true

        end

    end

    return false

end

--------------------------------------------------
-- ADD THREE
--------------------------------------------------

function board.addStep()

    for i = 1,
        config.ADD_STEP
    do

        board.addCard()

    end

end

--------------------------------------------------
-- REFILL
--------------------------------------------------

function board.refill()

    board.addStep()

    state.update(board)

end

--------------------------------------------------
-- GET CARD
--------------------------------------------------

function board.getCard(slotId)

    return
        board.slots[slotId]

end

--------------------------------------------------
-- REMOVE SELECTED
--------------------------------------------------

function board.removeSelected()
    assert( #state.selected == 3, "removeSelected requires exactly 3 selected cards.")
    for _, slotId in ipairs(state.selected)
    do

        local card =
            board.slots[slotId]

        assert(
            card ~= nil,
            "Attempt to discard nil card."
        )

        state.addToDiscard(card)

        board.slots[slotId] = nil

    end

    board.compact()

    if board.getCardCount() < config.MIN_CARDS then
        board.addStep()
    end

    state.update(board)

end

--------------------------------------------------
-- COMPACT
--------------------------------------------------

function board.compact()

    for empty = 1,
        config.MAX_SLOTS
    do

        if board.slots[empty] == nil
        then

            for from =
                config.MAX_SLOTS,
                empty + 1,
                -1
            do

                if board.slots[from]
                ~= nil
                then

                    local movedCard =
                        board.slots[from]

                    board.slots[empty] =
                        movedCard

                    board.slots[from] =
                        nil

                    state.enqueueAnimation({

                        card = movedCard,

                        from = from,

                        to = empty,

                        time = 0,

                        duration = 0.15

                    })

                    break

                end

            end

        end

    end

end

return board
