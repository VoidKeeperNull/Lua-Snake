local tile, width, height = 20, 30, 20
local move_dt = 0.10

local snake, dir, nextDir, applefood
local timer = 0
local alive = true

local function resetPlayer()
    snake = {{x=15, y=10}, {x=14, y=10}, {x=13, y=10}}
    dir = {dx = 1, dy = 0}
    nextDir = {dx = 1, dy = 0}
    alive =  true
    timer = 0
    applefood = {x = love.math.random(1, width), y = love.math.random(1, height)}
end

local function opposite(a, b) return a.dx == -b.dx and a.dy == - b.dy end

local function spawnApple()
    while true do 
        local ap = {x = love.math.random(1, width), y = love.math.random(1, height)}
        local placed = true
        for i=1,#snake do
            if snake[i].x == ap.x and snake[i].y == ap.y then placed = false break end
        end
        if placed then applefood = ap return end
    end
end

local function movePlayer()
    if not alive then return end
    dir = nextDir

    local hx, hy = snake[1].x, snake[1].y
    local nh = {x = hx + dir.dx, y = hy + dir.dy}

    if nh.x < 1 or nh.x > width or nh.y < 1 or nh.y > height then alive = false return end
    for i=1,#snake do
        if snake[i].x == nh.x and snake[i].y == nh.y then alive = false return end
    end

    table.insert(snake, 1, nh)

    if nh.x == applefood.x and nh.y == applefood.y then
        spawnApple()
    else
        table.remove(snake)
    end
end

function love.load()
    love.window.setTitle("LOVE Snake.lua")
    love.window.setMode(width*tile, height*tile)
    love.math.setRandomSeed(os.time())
    resetPlayer()
end

function love.keypressed(key)
    if key == "r" then resetPlayer() return end
    if not alive then return end
    
    local dirKey =
        (key=="up" or key=="w") and {dx=0,dy=-1} or
        (key=="down" or key=="s") and {dx=0,dy=1} or
        (key=="left" or key=="a") and {dx=-1,dy=0} or
        (key=="right" or key=="d") and {dx=1,dy=0}
    if dirKey and not opposite(dirKey, dir) then nextDir = dirKey end
end

function love.update(dt)
    timer = timer + dt
    if timer >= move_dt then
        timer = timer - move_dt
        movePlayer()
    end
end

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", (applefood.x-1)*tile, (applefood.y-1)*tile,tile,tile)

    local head = snake[1]
    love.graphics.setColor(0,0.5,0)
    love.graphics.rectangle("fill",(head.x-1)*tile,(head.y-1)*tile,tile,tile)

    for i=2,#snake do
        local s = snake[i]
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", (s.x-1)*tile, (s.y-1)*tile,tile,tile)
    end
    love.graphics.setColor(1, 1, 1)
    if not alive then love.graphics.print("Game Over! ('R' to restart)", 10, 10) end
end