--------------------------------------------------
-- SYMBOLS
--
-- Low-level geometric primitives, stencil masking, 
-- and pattern fills for card shapes.
--
-- Public API
--   draw(shape, fill, x, y, width, height, color)
--------------------------------------------------

local symbols = {}

--------------------------------------------------
-- PRIVATE METHODS (Locales)
--------------------------------------------------

local function drawStripes(x, y, width, height)

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

local function drawOval(fill, x, y, width, height)

    if fill == 0 then
        love.graphics.ellipse("line", x, y, width / 2, height / 2)

    elseif fill == 1 then
        love.graphics.stencil(function()
            love.graphics.ellipse("fill", x, y, width / 2, height / 2)
        end, "replace", 1)

        love.graphics.setStencilTest("greater", 0)
        drawStripes(x, y, width, height)
        love.graphics.setStencilTest()

        love.graphics.ellipse("line", x, y, width / 2, height / 2)

    elseif fill == 2 then
        love.graphics.ellipse("fill", x, y, width / 2, height / 2)
    end

end

local function drawRect(fill, x, y, width, height)

    local left = x - width / 2
    local top = y - height / 2

    if fill == 0 then
        love.graphics.rectangle("line", left, top, width, height)

    elseif fill == 1 then
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", left, top, width, height)
        end, "replace", 1)

        love.graphics.setStencilTest("greater", 0)
        drawStripes(x, y, width, height)
        love.graphics.setStencilTest()

        love.graphics.rectangle("line", left, top, width, height)

    elseif fill == 2 then
        love.graphics.rectangle("fill", left, top, width, height)
    end

end

local function drawDiamond(fill, x, y, width, height)

    local points = {
        x, y - height / 2,
        x + width / 2, y,
        x, y + height / 2,
        x - width / 2, y
    }

    if fill == 0 then
        love.graphics.polygon("line", points)

    elseif fill == 1 then
        love.graphics.stencil(function()
            love.graphics.polygon("fill", points)
        end, "replace", 1)

        love.graphics.setStencilTest("greater", 0)
        drawStripes(x, y, width, height)
        love.graphics.setStencilTest()

        love.graphics.polygon("line", points)

    elseif fill == 2 then
        love.graphics.polygon("fill", points)
    end

end

--------------------------------------------------
-- PUBLIC API
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

    -- Extraemos de forma segura los canales RGB y forzamos opacidad sólida (1.0)
    love.graphics.setColor(color[1], color[2], color[3], 1.0)

    if shape == 0 then
        drawOval(fill, x, y, width, height)
    elseif shape == 1 then
        drawRect(fill, x, y, width, height)
    elseif shape == 2 then
        drawDiamond(fill, x, y, width, height)
    end

end

return symbols