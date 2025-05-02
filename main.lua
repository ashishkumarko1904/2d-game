--load function
--update function
--draw function

function love.load()
    jack = {
        x = 0,
        y = 220,
        health = 100,
        charge = {
            cx = 0,
            cy = 220,
            active = false,
        },
        sprite = love.graphics.newImage("Wanderer Magican/Run.png"),
        animation = {
            direction = "right",
            frame = 1,
            maxFrame = 8,
            speed = 30,
            timer = 0.1,
        },
        idle = {
            standing = true,
            standingPose = love.graphics.newImage("Wanderer Magican/Idle.png"),
        },
        powersprite = love.graphics.newImage("Wanderer Magican/Attack_1.png"),
        powerPathSprite = love.graphics.newImage("Wanderer Magican/Charge_1.png"),
        poweranimation = {
            direction = "right",
            frame = 1,
            maxFrame = 7,
            speed = 30,
            timer = 0.1,
        },
        chargeanimation = {
            direction = "right",
            frame = 1,
            maxFrame = 9,
            speed = 30,
            timer = 0.1,
        },
        kills = 0,
    
        
    }
    wildzombie = {
        x = 1000,
        y = 190,
        health = 50,
        sprite = love.graphics.newImage("Wild Zombie/Idle-right.png"),
        animation = {
            direction = "right",
            frame = 1,
            maxFrame = 6,
            speed = 10,
            timer = 0.1,
        },
        spriteWidth = 864, --height: 96 px width: 864 px
        spriteHeight = 96,
        alive = true,
        attacking = false,
        attacksprite = love.graphics.newImage("Wild Zombie/Attack_3-right.png"),
        attackspriteWidth = 384, --height: 96 px width: 384 px
        attackspriteHeight = 96,
        attackanimation = {
            frame = 1,
            maxFrame = 4,
            speed = 10,
            timer = 0.1,
        },
    }

    womenzombie = {
        x = 800,
        y = 240,
        health = 150,
        sprite = love.graphics.newImage("Zombie Woman/Idle-right.png"),
        attacksprite = love.graphics.newImage("Zombie Woman/Attack_2-right.png"),
        animation = {
            direction = "right",
            frame = 4,
            maxFrame = 4,
            speed = 10,
            timer = 0.1,
        },
        spriteWidth = 384, --height: 96 px width: 384 px
        spriteHeight = 96,
        alive = true,
        attacking = false,
        walksprite = love.graphics.newImage("Zombie Woman/Walk-right.png"),
        walkspriteWidth = 672, --height: 96 px width: 672 px
        walkspriteHeight = 96,
        walkanimation = {
            frame = 7,
            maxFrame = 7,
            speed = 10,
            timer = 0.1,
        }
    }

    vampireBackground = love.graphics.newImage("1/terrace.png")
    -- height: 128 px width: 1024 px
    spriteWidth = 1024
    spriteHeight = 128
    quadWidth = spriteWidth / 8
    quadHeight = spriteHeight

    standingQuad = love.graphics.newQuad(1024/8, 0, 1024/8, 128, 1024, 128)

    quads = {}
    for i=1, jack.animation.maxFrame do
        quads[i] = love.graphics.newQuad((i-1)* quadWidth, 0, quadWidth, quadHeight, spriteWidth, spriteHeight)
    end
    love.graphics.setBackgroundColor(1,0.3,0.3)

-- power logic
    powquads = {}
    --attack 1 height: 128 px width: 896 px
    --charge 1 height: 128 px width: 576 px
    chargequads = {}
    powerSpriteWidth = 896
    powerSpriteHeight = 128
    chargeSpriteWidth = 576
    chargeSpriteHeight = 128
    chargeQuadWidth = chargeSpriteWidth / 9
    chargeQuadHeight = chargeSpriteHeight
    powerQuadWidth = powerSpriteWidth / 7
    powerQuadHeight = powerSpriteHeight
    for i=1,jack.poweranimation.maxFrame do
        powquads[i] = love.graphics.newQuad((i-1)* powerQuadWidth, 0, powerQuadWidth, powerQuadHeight, powerSpriteWidth, powerSpriteHeight)
    end
    for i=1, 9 do
        chargequads[i] = love.graphics.newQuad((i-1)* chargeQuadWidth, 0, chargeQuadWidth, chargeQuadHeight, chargeSpriteWidth, chargeSpriteHeight)
    end
    --zombie --height: 96 px width: 864 px
    zombie = love.graphics.newQuad(0, 0, 864/9, 96, wildzombie.spriteWidth, wildzombie.spriteHeight)

    --wildzombie attack animation
    zombiequads = {}
    for i=1,wildzombie.attackanimation.maxFrame do
        zombiequads[i] = love.graphics.newQuad((i-1)* (wildzombie.attackspriteWidth/4), 0, wildzombie.attackspriteWidth/4, wildzombie.attackspriteHeight, wildzombie.attackspriteWidth, wildzombie.attackspriteHeight)
    end
    --height: 96 px width: 480 px
    wz = love.graphics.newQuad(0, 0, 480/5, 96, 480, 96)  
    womenzombie.quads = {}
    for i=1,womenzombie.animation.maxFrame do
        womenzombie.quads[i] = love.graphics.newQuad((i-1)* (womenzombie.spriteWidth/4), 0, womenzombie.spriteWidth/4, womenzombie.spriteHeight, womenzombie.spriteWidth, womenzombie.spriteHeight)
    end

    walkwomenzombiequads = {}
    for i=1,womenzombie.walkanimation.maxFrame do
        walkwomenzombiequads[i] = love.graphics.newQuad((i-1)* (womenzombie.walkspriteWidth/7), 0, womenzombie.walkspriteWidth/7, womenzombie.walkspriteHeight, womenzombie.walkspriteWidth, womenzombie.walkspriteHeight)
    end

--sounds
    sounds = {}
    sounds.magic = love.audio.newSource("sounds/magic-spell.mp3", "static")
    sounds.wzomb = love.audio.newSource("sounds/zombie-2.mp3", "static")
    sounds.wdzomb = love.audio.newSource("sounds/zombie-1.mp3", "static")

end


function love.update(dt)
    if love.keyboard.isDown("right") then 
        jack.idle.standing = false
        jack.animation.timer = jack.animation.timer + dt
        if jack.animation.timer > dt*4 then
            jack.animation.frame = jack.animation.frame + 1
            jack.animation.timer = 0
        end
        if jack.animation.frame >= jack.animation.maxFrame then
            jack.animation.frame = 1
        end
        if jack.x < 1100 then
        jack.x = jack.x + (jack.animation.speed * dt*4)
        end
    else
        jack.idle.standing = true
        jack.animation.frame = 1
    end

    --animation for power sprite
    if love.keyboard.isDown("p") then
        jack.charge.active = true
        jack.poweranimation.timer = jack.poweranimation.timer + dt
        if jack.poweranimation.timer > dt*4 then
            jack.charge.cx = jack.x+200
            jack.poweranimation.frame = jack.poweranimation.frame + 1
            jack.poweranimation.timer = 0
        end
        if jack.poweranimation.frame >= jack.poweranimation.maxFrame then
            jack.poweranimation.frame = 1
        end
        jack.chargeanimation.timer = jack.chargeanimation.timer + dt
        if jack.chargeanimation.timer > dt*4 then
            jack.chargeanimation.frame = jack.chargeanimation.frame + 1
            jack.chargeanimation.timer = 0
        end
        if jack.chargeanimation.frame >= jack.chargeanimation.maxFrame then
            jack.chargeanimation.frame = 1
        end
    else
        jack.charge.active = false
        jack.charge.cx = jack.x  
    end
   
    --wildzombie attacking logic
    if jack.x >= wildzombie.x - 150 then
        if wildzombie.alive == true then
            wildzombie.attacking = true
        end
        wildzombie.attackanimation.timer = wildzombie.attackanimation.timer + dt
        if wildzombie.attackanimation.timer > dt*15 then
            wildzombie.attackanimation.frame = wildzombie.attackanimation.frame + 1
            wildzombie.attackanimation.timer = 0
        end
        if wildzombie.attackanimation.frame >= wildzombie.attackanimation.maxFrame then
            wildzombie.attackanimation.frame = 1
            if jack.x >= wildzombie.x - 130 and wildzombie.attacking == true then
                jack.health = jack.health - 10
            end
        end
        
        if jack.health <= 0 then
            jack.health = 0
            wildzombie.attacking = false
            wildzombie.alive = false
        end
    else
        wildzombie.attacking = false
    end

 --womenzombie attacking logic
    if womenzombie.x - jack.x <= 180 then
        if womenzombie.alive == true then
            womenzombie.attacking = true
        end
        womenzombie.animation.timer = womenzombie.animation.timer + dt
        if womenzombie.animation.timer > dt*15 then
            womenzombie.animation.frame = womenzombie.animation.frame - 1
            womenzombie.animation.timer = 0
            
        end
        if womenzombie.animation.frame <= 0 then
            womenzombie.animation.frame = 4
            if (womenzombie.x - jack.x > 0 )and (womenzombie.x - jack.x < 180) and womenzombie.attacking == true then
                jack.health = jack.health - 10
            end
        end
        if jack.health <= 0 then
            jack.health = 0
            womenzombie.attacking = false
            womenzombie.alive = false
        end
    else
        womenzombie.attacking = false
    end


   if math.abs(jack.x - womenzombie.x) > 100 then
        womenzombie.x = womenzombie.x - (womenzombie.walkanimation.speed * dt*4)
        womenzombie.walkanimation.timer = womenzombie.walkanimation.timer + dt
        if womenzombie.walkanimation.timer > dt*4 then
            womenzombie.walkanimation.frame = womenzombie.walkanimation.frame - 1
            womenzombie.walkanimation.timer = 0
        end
        if womenzombie.walkanimation.frame <= 0 then
            womenzombie.walkanimation.frame = 7
        end
    end
    
    if womenzombie.attacking == true then
        sounds.wdzomb:play()
    end
    if womenzombie.alive == false then
        sounds.wdzomb:stop()
    end
    if wildzombie.attacking == true then
        sounds.wzomb:play()
    end
    if wildzombie.alive == false then
        sounds.wzomb:stop()
    end


end

function love.draw()
    
    love.graphics.draw(vampireBackground, 0, 0,0,0.37,0.32)

    love.graphics.print("health:",10,0)
    love.graphics.print(jack.health, 10, 20)
    love.graphics.print("kills:", 10, 40)
    love.graphics.print(jack.kills, 10, 60)
    love.graphics.print("zombie health:", 800, 20)
    love.graphics.print(wildzombie.health, 800, 40)
    love.graphics.print("womenzombie health:", 800, 60)
    love.graphics.print(womenzombie.health, 800, 80)

    if jack.idle.standing then
        if love.keyboard.isDown("p") then
            love.graphics.draw(jack.powersprite,powquads[jack.poweranimation.frame], jack.x, jack.y,0,1.6,1.8)
            love.graphics.draw(jack.powerPathSprite,chargequads[jack.chargeanimation.frame], jack.charge.cx, jack.y,0,1.6,1.8)
        else
            love.graphics.draw(jack.idle.standingPose, standingQuad,jack.x, jack.y,0,1.6,1.8)
        end
    else
        love.graphics.draw(jack.sprite, quads[jack.animation.frame], jack.x, jack.y,0,1.6,1.8)
    end
   -- love.graphics.draw(jack.sprite, quads[jack.animation.frame], jack.x, jack.y,0,1.6,1.8)
    if wildzombie.attacking == true then
        love.graphics.draw(wildzombie.attacksprite, zombiequads[wildzombie.attackanimation.frame], wildzombie.x, wildzombie.y,0,2.4,2.8)
    elseif wildzombie.alive == true then
        love.graphics.draw(wildzombie.sprite, zombie, wildzombie.x, wildzombie.y,0,2.4,2.8)
    end

    if jack.health <= 0 then
        love.graphics.print("Game Over", 500, 300)
    end

    
    
      --  love.graphics.draw(womenzombie.attacksprite, womenzombie.quads[womenzombie.animation.frame], womenzombie.x, womenzombie.y,0,1.4,1.8)
    if womenzombie.alive == true and math.abs(jack.x - womenzombie.x) >= 100 then
        love.graphics.draw(womenzombie.walksprite, walkwomenzombiequads[womenzombie.walkanimation.frame], womenzombie.x, womenzombie.y,0,1.4,1.8)
    elseif womenzombie.alive == true and womenzombie.attacking == true then
        love.graphics.draw(womenzombie.attacksprite, womenzombie.quads[womenzombie.animation.frame], womenzombie.x, womenzombie.y,0,1.4,1.8)
    elseif womenzombie.alive == true and womenzombie.attacking == false and womenzombie.x == 800 then
        love.graphics.draw(womenzombie.sprite, wz, womenzombie.x, womenzombie.y,0,1.4,1.8)
    end
    if jack.kills == 2 then
        love.graphics.print("You win", 500, 300)
    end

end

function love.keypressed(key)
    if key == "p" then
        sounds.magic:play()
    end
    if key == "p" and jack.x >= wildzombie.x - 200 and wildzombie.health > 0 then
        wildzombie.health = wildzombie.health - 10
        if wildzombie.health <= 0 then
            wildzombie.attacking = false
            wildzombie.alive = false
            jack.kills = jack.kills + 1
        end
    end
    if key == "p" and womenzombie.x - jack.x <= 180 and womenzombie.health > 0 then
        womenzombie.health = womenzombie.health - 25
        if womenzombie.health <= 0 then
            womenzombie.attacking = false
            womenzombie.alive = false
            jack.kills = jack.kills + 1
        end
    end
end
