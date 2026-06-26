local solver =
    require("game.solver")

local config =
    require("core.config")

local animations =
    require("render.animations")

local state = {}

local discard = {}

--------------------------------------------------
-- INIT
--------------------------------------------------

function state.init()

    --------------------------------------------------
    -- GAME
    --------------------------------------------------

    state.gameOver = false

    state.paused = false

    state.seed = nil

    state.discard = { cards = {} }

    --------------------------------------------------
    -- DERIVED
    --------------------------------------------------

    state.hasSets = false

    state.deckEmpty = false

    --------------------------------------------------
    -- INPUT
    --------------------------------------------------

    state.selected = {}

    state.hoveredSlot = nil

    --------------------------------------------------
    -- ANIMATION
    --------------------------------------------------

    state.inAnimation = false

    state.animation = {

        queued = {}

    }

    --------------------------------------------------
    -- SYSTEM RESET
    --------------------------------------------------

    animations.reset()

end

function state.reset()

    state.init()

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function state.update(board)

    --------------------------------------------------
    -- DERIVED
    --------------------------------------------------

    state.hasSets =

        solver.hasSets(
            board.slots
        )

    state.deckEmpty =

        #board.deck.cards <= 0

    --------------------------------------------------
    -- GAME OVER
    --------------------------------------------------

    state.gameOver =

        (not state.hasSets)
        and
        state.deckEmpty
        and
        (not state.inAnimation)
        and
        (not state.hasQueuedAnimations())

end

--------------------------------------------------
-- UPDATE ANIMATIONS
--------------------------------------------------

function state.updateAnimations(dt)

    --------------------------------------------------
    -- RUNTIME
    --------------------------------------------------

    animations.update(dt)

    --------------------------------------------------
    -- PIPELINE
    --------------------------------------------------

    state.doAnimation()

end

--------------------------------------------------
-- SELECTION
--------------------------------------------------

function state.isSelected(slotId)

    for _, selectedSlot
        in ipairs(state.selected)
    do

        if selectedSlot == slotId then
            return true
        end

    end

    return false

end

function state.clearSelection()

    state.selected = {}

end

function state.toggleSelection(slotId)

    --------------------------------------------------
    -- REMOVE
    --------------------------------------------------

    for i, selectedSlot
        in ipairs(state.selected)
    do

        if selectedSlot == slotId then

            table.remove(
                state.selected,
                i
            )

            return

        end

    end

    --------------------------------------------------
    -- ADD
    --------------------------------------------------

    if #state.selected >= config.MAX_SELECTION then
        return
    end

    table.insert(
        state.selected,
        slotId
    )

end

--------------------------------------------------
-- ANIMATION QUEUE
--------------------------------------------------

function state.enqueueAnimation(data)

    assert(data ~= nil)

    table.insert(
        state.animation.queued,
        data
    )

end

function state.pullNextAnimation()

    if #state.animation.queued <= 0 then
        return nil
    end

    return table.remove(
        state.animation.queued,
        1
    )

end

function state.hasQueuedAnimations()

    return
        #state.animation.queued > 0

end

--------------------------------------------------
-- ANIMATION PIPELINE
--------------------------------------------------

function state.doAnimation()

    --------------------------------------------------
    -- CURRENT PIPELINE
    --------------------------------------------------

    if state.inAnimation then

        --------------------------------------------------
        -- STILL RUNNING
        --------------------------------------------------

        if animations.isBusy() then
            return
        end

        --------------------------------------------------
        -- FINISHED
        --------------------------------------------------

        state.inAnimation = false

    end

    --------------------------------------------------
    -- NEXT
    --------------------------------------------------

    local animation =

        state.pullNextAnimation()

    if animation == nil then
        return
    end

    --------------------------------------------------
    -- RUN
    --------------------------------------------------

    state.inAnimation = true

    animations.run(animation)

end

--------------------------------------------------
-- HELPERS
--------------------------------------------------

function state.isAnimating()

    return state.inAnimation

end


function state.addToDiscard(card)

    table.insert(
        state.discard.cards,
        card
    )

end

function state.getDiscardCount()

    return #state.discard.cards

end
--------------------------------------------------
-- BOOT
--------------------------------------------------

state.init()

return state