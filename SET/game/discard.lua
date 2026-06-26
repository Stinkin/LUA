local discard = {}

-------------------------------------------------
-- CREATE
--------------------------------------------------

function discard.create()

    local self = {}

    self.cards = {}

    return self

end

--------------------------------------------------
-- ADD
--------------------------------------------------

function discard.add(self, card)

    table.insert(self.cards, card)

end

-------------------------------------------------
-- DRAW
--------------------------------------------------

function discard.draw(self)

    return table.remove(self.cards)

end


--------------------------------------------------
-- EMPTY
--------------------------------------------------

function discard.isEmpty(self)

    return #self.cards == 0

end

--------------------------------------------------
-- CARD COUNT
--------------------------------------------------

function discard.getCardCount(self)

    return #self.cards

end

return discard
