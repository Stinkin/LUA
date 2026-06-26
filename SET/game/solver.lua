local setlogic = require("game.setlogic")

local solver = {}

--------------------------------------------------
-- FIND SETS
--------------------------------------------------

function solver.findSets(slots)

    local sets = {}

    --------------------------------------------------
    -- BUILD CARD LIST
    --------------------------------------------------

    local cards = {}

    for slotId, card in ipairs(slots) do

        if card ~= nil then

            table.insert(cards, {

                slotId = slotId,
                card = card

            })

        end

    end

    --------------------------------------------------
    -- TEST COMBINATIONS
    --------------------------------------------------

    for i = 1, #cards - 2 do

        for j = i + 1, #cards - 1 do

            for k = j + 1, #cards do

                local a = cards[i]
                local b = cards[j]
                local c = cards[k]

                if setlogic.isSet(
                    a.card,
                    b.card,
                    c.card
                ) then

                    table.insert(sets, {

                        a.slotId,
                        b.slotId,
                        c.slotId

                    })

                end

            end

        end

    end

    return sets

end

--------------------------------------------------
-- COUNT SETS
--------------------------------------------------

function solver.countSets(slots)

    return #solver.findSets(slots)

end

--------------------------------------------------
-- HAS SETS
--------------------------------------------------

function solver.hasSets(slots)

    return solver.countSets(slots) > 0

end

--------------------------------------------------
-- GET FIRST SET
--------------------------------------------------

function solver.getFirstSet(slots)

    local sets =
        solver.findSets(slots)

    return sets[1]

end

return solver