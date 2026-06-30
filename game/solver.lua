--------------------------------------------------
-- SOLVER -- FINISHED
--
-- Analyzes the board slots to find, count, or verify Sets.
--
-- Public API
--
-- Queries
--   findAllSets(slots)
--   countSets(slots)
--   hasSets(slots)
--   getFirstSet(slots)
--------------------------------------------------
local setlogic = require("game.setlogic")

local solver = {}

--------------------------------------------------
-- SEARCH ** PRIVATE FUNCTION **
--------------------------------------------------
local function searchForSets(slots, stopOnFirst)
    local sets = {}
    local cards = {}

    -- ipairs es 100% seguro gracias al invariante de board.compact()
    for slotId, card in ipairs(slots) do
        if card ~= nil then
            table.insert(cards, {
                slotId = slotId,
                card = card
            })
        end
    end

    -- Bucle combinatorio
    for i = 1, #cards - 2 do
        for j = i + 1, #cards - 1 do
            for k = j + 1, #cards do
                local a = cards[i]
                local b = cards[j]
                local c = cards[k]

                if setlogic.isSet(a.card, b.card, c.card) then
                    local foundSet = { a.slotId, b.slotId, c.slotId }
                    
                    if stopOnFirst then
                        return { foundSet }
                    end
                    
                    table.insert(sets, foundSet)
                end
            end
        end
    end

    return sets
end

--------------------------------------------------
-- FIND SETS
--------------------------------------------------
function solver.findAllSets(slots)
    assert(slots ~= nil)
    return searchForSets(slots, false)
end

--------------------------------------------------
-- COUNT SETS
--------------------------------------------------

function solver.countSets(slots)
    assert(slots ~= nil)
    return #solver.findAllSets(slots)
end

--------------------------------------------------
-- HAS SETS
--------------------------------------------------

function solver.hasSets(slots)
    assert(slots ~= nil)   
    return solver.getFirstSet(slots) ~= nil
end

--------------------------------------------------
-- GET FIRST SET
--------------------------------------------------

function solver.getFirstSet(slots)
    assert(slots ~= nil)
    local firstSet = searchForSets(slots, true)
    return firstSet[1] -- SearchForSets allways return list
end

return solver