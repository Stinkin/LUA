local state =
    require("game.state")

local setlogic =
    require("game.setlogic")

local solver =
    require("game.solver")

local gameplay = {}

--------------------------------------------------
-- RESOLVE SELECTION
--------------------------------------------------

function gameplay.resolveSelection(board)

    if #state.selected < 3
    then
        return
    end

    local a =
        board.getCard(
            state.selected[1]
        )

    local b =
        board.getCard(
            state.selected[2]
        )

    local c =
        board.getCard(
            state.selected[3]
        )

    --------------------------------------------------
    -- VALID SET
    --------------------------------------------------

    if setlogic.isSet(a, b, c)
    then

        board.removeSelected()

    end

    --------------------------------------------------
    -- CLEAR
    --------------------------------------------------

    state.clearSelection()

end

--------------------------------------------------
-- HINT
--------------------------------------------------

function gameplay.showHint(board)

    local set =
        solver.getFirstSet(
            board.slots
        )

    if not set then
        return
    end

    --------------------------------------------------
    -- CLEAR CURRENT
    --------------------------------------------------

    state.clearSelection()

    --------------------------------------------------
    -- SELECT TWO
    --------------------------------------------------

    state.toggleSelection(
        set[1]
    )

    state.toggleSelection(
        set[2]
    )

end

function gameplay.refill(board)

    board.refill()

    state.update(board)

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function gameplay.update(board)

end

return gameplay