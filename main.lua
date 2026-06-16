local player = {}
local defender = {}
local defender2 = {}
local speed = 500
local gameHeight = love.graphics.getHeight()
local gameWidth = love.graphics.getWidth()
local score = 0
local message = ""
local messageTimer = 0
local frameTime = 0.2
local elapsed = 0


function love.load()
    player.frames = {
        love.graphics.newImage("lbj.png"),
        love.graphics.newImage("lbj2.png")
    }

    player.currentFrame = 1
    player.image = player.frames[player.currentFrame]
    player.x = (gameWidth - player.image:getWidth()) / 2
    player.y = gameHeight - player.image:getHeight()
    player.facingRight = true

    function resetDefender()
        defender.image = love.graphics.newImage("curry.png")
        defender.x = math.min(love.math.random(0,100),love.graphics.getWidth() - defender.image:getWidth())
        defender.y = 0

        --defender.y = love.math.random(defender.x+gap,gameWidth)
        defender2.image = love.graphics.newImage("curry.png")
        defender2.x =  math.min(love.math.random(defender.x + player.image:getWidth(), gameWidth),love.graphics.getWidth() - defender2.image:getWidth())
        defender2.y = 0

    end
    resetDefender()

end

function checkCollision(a, b)
    return a.x < b.x + b.image:getWidth() and
           a.x + a.image:getWidth() > b.x and
           a.y < b.y + b.image:getHeight() and
           a.y + a.image:getHeight() > b.y
end

function checkScore() 
    return player.x > defender.x + defender.image:getWidth() and player.y + player.image:getHeight() - 1 <= defender.y or 
        player.x > defender2.x + defender2.image:getWidth() and player.y + player.image:getHeight() -1 <= defender.y or 
        player.x < defender.x and player.y + player.image:getHeight() -1 <= defender.y
    end

function love.update(dt)
    defender.y = defender.y + (120*dt)
    defender2.y = defender2.y + (120*dt)

    elapsed = elapsed + dt
    if elapsed >= frameTime then 
        elapsed = 0 
        player.currentFrame = player.currentFrame % #player.frames + 1
        player.image = player.frames[player.currentFrame]
    end

    -- if love.keyboard.isDown("space") then
    --     love.load()
    -- end

    if love.keyboard.isDown("right") then
        player.x = math.min(player.x + speed * dt, love.graphics.getWidth() - player.image:getWidth())
    end

    if love.keyboard.isDown("left") then
        player.x = math.max(player.x - speed * dt, 0)
    end  

    if (defender.y ) > gameHeight then
        resetDefender()
    end

    if checkCollision(player, defender) then
        message = "Offensive Foul!"
        score = 0
        messageTimer = 2
        resetDefender()
    end

    if checkCollision(player, defender2) then
        message = "Offensive Foul!"
        score = 0
        messageTimer = 2
        resetDefender()
    end

    if checkScore() then
        score = score + 1 
    end

    if messageTimer > 0 then
        messageTimer = messageTimer - dt
    end
    
    if messageTimer <= 0 then
        message = ""
    end

end

function love.draw()
    love.graphics.print("Use <- and -> keys to move",300, 0)
    love.graphics.setBackgroundColor(0.753, 0.639, 0.451)
    love.graphics.draw(player.image,player.x,player.y)
    love.graphics.draw(defender.image,defender.x,defender.y)
    love.graphics.draw(defender2.image,defender2.x,defender2.y)
    love.graphics.print(string.format("Score: %d", score),10,10)
    love.graphics.print(message,350, 300)

    --love.graphics.rectangle('fill',0,0,defender1Width,110) -- Left Defender
    --love.graphics.rectangle("fill",defender1Width + gapWidth, 0, gameWidth-defender1Width-gapWidth,110)
    --love.graphics.setColor(1, 0, 0)

    --hitbox
    -- love.graphics.rectangle(
    --     "line",
    --     player.x,
    --     player.y,
    --     player.image:getWidth(),
    --     player.image:getHeight()
    -- )

    -- love.graphics.rectangle(
    --     "line",
    --     defender.x,
    --     defender.y,
    --     defender.image:getWidth(),
    --     defender.image:getHeight()
    -- )

    -- love.graphics.rectangle(
    --     "line",
    --     defender2.x,
    --     defender2.y,
    --     defender2.image:getWidth(),
    --     defender2.image:getHeight()
    -- )

    --love.graphics.setColor(1, 1, 1)
    end
