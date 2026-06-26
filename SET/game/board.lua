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
-- INITIALIZE
--------------------------------------------------

function board.initialize()

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
