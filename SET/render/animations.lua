local animations = {}

--------------------------------------------------
-- RUNTIME
--------------------------------------------------

animations.current = nil

--------------------------------------------------
-- RUN
--------------------------------------------------

function animations.run(data)

    assert(data ~= nil)

    animations.current =
        data

end

--------------------------------------------------
-- RESET
--------------------------------------------------

function animations.reset()

    animations.current =
        nil

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function animations.update(dt)

    --------------------------------------------------
    -- CURRENT
    --------------------------------------------------

    if not animations.current
    then
        return true
    end

    local completed =

        animations.doAnimation(

            animations.current,

            dt

        )

    --------------------------------------------------
    -- COMPLETE
    --------------------------------------------------

    if completed then

        animations.current =
            nil

        return true

    end

    return false

end

--------------------------------------------------
-- DO ANIMATION
--------------------------------------------------

function animations.doAnimation(data, dt)

    --------------------------------------------------
    -- PLACEHOLDER
    --------------------------------------------------

    return true

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function animations.draw()

end

--------------------------------------------------
-- ANIMATING
--------------------------------------------------

function animations.isAnimating(card)

    if not animations.current
    then
        return false
    end

    return

        animations.current.card
        == card

end
--------------------------------------------------
-- BUSY
--------------------------------------------------

function animations.isBusy()

    return
        animations.current ~= nil

end
return animations