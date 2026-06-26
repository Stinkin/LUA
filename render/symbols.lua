local symbols = {}

--------------------------------------------------
-- STRIPES
--------------------------------------------------

local function drawStripes(

    x,
    y,

    width,
    height

)

    local spacing = 8

    for offset = -width, width, spacing do

        love.graphics.line(

            x + offset,
            y - height,

            x + offset + height,
            y + height

        )

    end

end

--------------------------------------------------
-- OVAL
--------------------------------------------------

local function drawOval(

    fill,

    x,
    y,

    width,
    height

)

    --------------------------------------------------
    -- OUTLINE
    --------------------------------------------------

    if fill == 0 then

        love.graphics.ellipse(

            "line",

            x,
            y,

            width / 2,
            height / 2

        )

    --------------------------------------------------
    -- STRIPED
    --------------------------------------------------

    elseif fill == 1 then

        --------------------------------------------------
        -- STENCIL
        --------------------------------------------------

        love.graphics.stencil(

            function()

                love.graphics.ellipse(

                    "fill",

                    x,
                    y,

                    width / 2,
                    height / 2

                )

            end,

            "replace",
            1

        )

        love.graphics.setStencilTest(
            "greater",
            0
        )

        drawStripes(
            x,
            y,
            width,
            height
        )

        love.graphics.setStencilTest()

        love.graphics.ellipse(

            "line",

            x,
            y,

            width / 2,
            height / 2

        )

    --------------------------------------------------
    -- SOLID
    --------------------------------------------------

    elseif fill == 2 then

        love.graphics.ellipse(

            "fill",

            x,
            y,

            width / 2,
            height / 2

        )

    end

end

--------------------------------------------------
-- RECT
--------------------------------------------------

local function drawRect(

    fill,

    x,
    y,

    width,
    height

)

    local left =
        x - width / 2

    local top =
        y - height / 2

    --------------------------------------------------
    -- OUTLINE
    --------------------------------------------------

    if fill == 0 then

        love.graphics.rectangle(

            "line",

            left,
            top,

            width,
            height

        )

    --------------------------------------------------
    -- STRIPED
    --------------------------------------------------

    elseif fill == 1 then

        love.graphics.stencil(

            function()

                love.graphics.rectangle(

                    "fill",

                    left,
                    top,

                    width,
                    height

                )

            end,

            "replace",
            1

        )

        love.graphics.setStencilTest(
            "greater",
            0
        )

        drawStripes(
            x,
            y,
            width,
            height
        )

        love.graphics.setStencilTest()

        love.graphics.rectangle(

            "line",

            left,
            top,

            width,
            height

        )

    --------------------------------------------------
    -- SOLID
    --------------------------------------------------

    elseif fill == 2 then

        love.graphics.rectangle(

            "fill",

            left,
            top,

            width,
            height

        )

    end

end

--------------------------------------------------
-- DIAMOND
--------------------------------------------------

local function drawDiamond(

    fill,

    x,
    y,

    width,
    height

)

    local points = {

        x,
        y - height / 2,

        x + width / 2,
        y,

        x,
        y + height / 2,

        x - width / 2,
        y

    }

    --------------------------------------------------
    -- OUTLINE
    --------------------------------------------------

    if fill == 0 then

        love.graphics.polygon(
            "line",
            points
        )

    --------------------------------------------------
    -- STRIPED
    --------------------------------------------------

    elseif fill == 1 then

        love.graphics.stencil(

            function()

                love.graphics.polygon(
                    "fill",
                    points
                )

            end,

            "replace",
            1

        )

        love.graphics.setStencilTest(
            "greater",
            0
        )

        drawStripes(
            x,
            y,
            width,
            height
        )

        love.graphics.setStencilTest()

        love.graphics.polygon(
            "line",
            points
        )

    --------------------------------------------------
    -- SOLID
    --------------------------------------------------

    elseif fill == 2 then

        love.graphics.polygon(
            "fill",
            points
        )

    end

end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function symbols.draw(

    shape,
    fill,

    x,
    y,

    width,
    height,

    color

)

    love.graphics.setColor(color)

    --------------------------------------------------
    -- OVAL
    --------------------------------------------------

    if shape == 0 then

        drawOval(

            fill,

            x,
            y,

            width,
            height

        )

    --------------------------------------------------
    -- RECT
    --------------------------------------------------

    elseif shape == 1 then

        drawRect(

            fill,

            x,
            y,

            width,
            height

        )

    --------------------------------------------------
    -- DIAMOND
    --------------------------------------------------

    elseif shape == 2 then

        drawDiamond(

            fill,

            x,
            y,

            width,
            height

        )

    end

end

return symbols