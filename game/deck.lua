--------------------------------------------------
-- GESTION DEL TABLERO DE JUEGO
--
-- 
--
--
--
-- 
--------------------------------------------------


local card = require("game.card")

local deck = {}

--------------------------------------------------
-- CREATE
--------------------------------------------------

function deck.create()

    local self = {}

    self.cards = {}
    self.seed = nil

    for color = 0, 2 do
        for shape = 0, 2 do
            for count = 0, 2 do
                for fill = 0, 2 do

                    table.insert(

                        self.cards,

                        card.create(
                            color,
                            shape,
                            count,
                            fill
                        )

                    )

                end
            end
        end
    end

    return self

end

--------------------------------------------------
-- SHUFFLE SEED
--------------------------------------------------

function deck.shuffleSeed(

    self,
    seed

)

    self.seed = seed

    math.randomseed(seed)

    for i = #self.cards, 2, -1 do

        local j = math.random(i)

        self.cards[i],
        self.cards[j] =

            self.cards[j],
            self.cards[i]

    end

end

--------------------------------------------------
-- SHUFFLE
--------------------------------------------------

function deck.shuffle(self, seed)

    seed =
        seed or os.time()

    deck.shuffleSeed(
        self,
        seed
    )

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function deck.draw(self)

    return table.remove(self.cards)

end
--------------------------------------------------
-- ADD
--------------------------------------------------

function deck.add(card)

    table.insert(self.cards, card)

end

--------------------------------------------------
-- EMPTY
--------------------------------------------------

function deck.isEmpty(self)

    return #self.cards == 0

end

--------------------------------------------------
-- CARD COUNT
--------------------------------------------------

function deck.getCardCount(self)

    return #self.cards

end

return deck
