--------------------------------------------------
-- DECK
--
-- Owns the deck and preserves its invariants.
--
-- Public API
--
-- Lifecycle
--   create()
--   initialize()
--   clear()
--
-- Queries
--   getCardCount()
--   isEmpty()
--
-- Commands
--   shuffle(seed)
--   draw()
--   add(card)
--------------------------------------------------


local card = require("game.card")

local deck = {}
--------------------------------------------------
-- CREATE
--------------------------------------------------
function deck.create()
    
    return {
        cards = {}
    }

end


--------------------------------------------------
-- INITIALIZE
--------------------------------------------------

function deck.initialize()

    local self = {}
--------------------------------------------------
-- DECK
--
-- Owns the deck and preserves its invariants.
--
-- Public API
--
-- Lifecycle
--   create()
--   initialize()
--   clear()
--
-- Queries
--   getCardCount()
--   isEmpty()
--
-- Commands
--   shuffle(seed)
--   draw()
--   add(card)
--------------------------------------------------


local card = require("game.card")

local deck = {}
--------------------------------------------------
-- CREATE
--------------------------------------------------
function deck.create()
    
    return {
        cards = {}
    }

end


--------------------------------------------------
-- INITIALIZE
--------------------------------------------------

function deck.initialize(self)

    self.cards = {}
    self.seed = nil

    for color = 0, 2 do
        for shape = 0, 2 do
            for count = 0, 2 do
                for fill = 0, 2 do
                    table.insert(
                        self.cards,
                        card.create(color, shape, count, fill)
                    )
                end
            end
        end
    end
end

--------------------------------------------------
-- CLEAR
--------------------------------------------------

function deck.clear(self)
    self.cards = {}
end

--------------------------------------------------
-- CARD COUNT
--------------------------------------------------

function deck.getCardCount(self)

    return #self.cards

end

--------------------------------------------------
-- IS_EMPTY
--------------------------------------------------

function deck.isEmpty(self)

    return deck.getCardCount(self) == 0

end


--------------------------------------------------
-- SHUFFLE
-- Fisher-Yates algorithm
--------------------------------------------------

function deck.shuffle(self,seed)
    seed = seed or os.time()
    math.randomseed(seed)
    for i = #self.cards, 2, -1 do
        local j = math.random(i)
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function deck.draw(self)
    assert(not deck.isEmpty(self))
    return table.remove(self.cards)
end
--------------------------------------------------
-- ADD
--------------------------------------------------

function deck.add(self, aCard)
    assert(self ~= nil)
    assert(aCard ~= nil)
    table.insert(self.cards, aCard)
end

return deck
