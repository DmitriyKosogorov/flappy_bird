require("vector")
require("background")
require("bottom")
require("bird")
require("pipe")
require("counter")
require("texter")

local status="Menu"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    number_of_backgrounds=6
    number_of_bottoms=5
    number_of_pipes=5

    texter=Texter:create(width,height)

    counter=Counter:create(width, height)
    prev_count=0

    local texture_background_width=love.graphics.newImage("assets/sprites/background-day.png"):getWidth()
    local texture_bottom_width=love.graphics.newImage("assets/sprites/base.png"):getWidth()
    texture_bottom_height=love.graphics.newImage("assets/sprites/base.png"):getHeight()

    speed=5
    
    pass_sound=love.audio.newSource("assets/audio/point.wav", "static")

    backgrounds={}
    for i=0, number_of_backgrounds do
        backgrounds[i]=Background:create(texture_background_width*i,0,width, height,2)
    end

    bottoms={}
    for i=0, number_of_bottoms do
        bottoms[i]=Bottom:create(texture_bottom_width*i,height-texture_bottom_height,width, height,speed)
    end
    pipes={}
    for i=0,number_of_pipes do
        pipes[i]=Pipe:create(width+i*500,love.math.random(150, height-texture_bottom_height-150), width, height,speed,"usual")
    end

    bird=Bird:create(100,(height-texture_bottom_height)/2,width, height)
    timer=love.timer.getTime()
end

function love.update(dt)
    for i=0, number_of_backgrounds do
        backgrounds[i]:update(status)
    end

    for i=0, number_of_bottoms do
        bottoms[i]:update(status)
    end


    if(status=="Playing") then
    for i=0, number_of_pipes do
            pipes[i]:update(status)
            pipes[i]:check_boundaries(bird)
            
            if(pipes[i].passed==false and bird.position.x>pipes[i].position.x+pipes[i].texture:getWidth()) then
                pipes[i].passed=true
                love.audio.play(pass_sound)
                counter:up()
            end
        end

        if(pipes[0].position.x+pipes[0].texture:getWidth()<=-10) then
            local savepipe=pipes[0]
            for i=1,number_of_pipes do
                pipes[i-1]=pipes[i]
            end
            pipes[number_of_pipes]=savepipe
            pipes[number_of_pipes].position.x=pipes[number_of_pipes-1].position.x+500
            pipes[number_of_pipes].position.y=love.math.random(150, height-texture_bottom_height-150)
            pipes[number_of_pipes].passed=false
        end

        if(bottoms[0].position.x+bottoms[0].texture:getWidth()<=-10) then
            local savebot=bottoms[0]
            for i=1,number_of_bottoms do
                bottoms[i-1]=bottoms[i]
            end
            bottoms[number_of_bottoms]=savebot
            bottoms[number_of_bottoms].position.x=bottoms[number_of_bottoms-1].position.x+bottoms[number_of_bottoms-1].texture:getWidth()
            bottoms[number_of_bottoms].passed=false
        end

        if(backgrounds[0].position.x+backgrounds[0].texture_day:getWidth()<=-10) then
            local savebot=backgrounds[0]
            for i=1,number_of_backgrounds do
                backgrounds[i-1]=backgrounds[i]
            end
            backgrounds[number_of_backgrounds]=savebot
            backgrounds[number_of_backgrounds].position.x=backgrounds[number_of_backgrounds-1].position.x+backgrounds[number_of_backgrounds-1].texture_day:getWidth()
            backgrounds[number_of_backgrounds].passed=false
        end

    end

    bird:update()

    if(bird.status=="Crashed" or bird.status=="Lying") then
        status="Stop"
    end

    if(status=="Menu") then
        texter.status="Welcome"
    end
    if(status~="Menu" and texter.status=="Welcome") then
        texter.status="Welcomeout"
    end
    if(status=="Stop" and texter.status~="Gameoverin" and texter.status~="Gameover") then
        texter.status="Gameoverin"
        texter.position.x=0
    end

    if(counter.count-prev_count>=20) then
        prev_count=counter.count
        timer=love.timer.getTime()

        for i=0, number_of_pipes do
            pipes[i].speed=pipes[i].speed+3
        end

        

        for i=0, number_of_backgrounds do
            backgrounds[i].speed=backgrounds[i].speed+1
        end


    
        for i=0, number_of_bottoms do
            bottoms[i].speed=bottoms[i].speed+3
            if(i>0) then
                bottoms[i].position.x=bottoms[i-1].position.x+bottoms[i-1].texture:getWidth()
            end
        end
    end

    texter:update()
end

function love.draw()

    for i=0, number_of_backgrounds do
        backgrounds[i]:draw()
    end

    for i=0, number_of_pipes do
        pipes[i]:draw()
    end

    for i=0, number_of_bottoms do
        bottoms[i]:draw()
    end

    bird:draw()
    if(status~="Menu") then
        counter:draw()
    end

    texter:draw()


end

function love.keypressed(key)
    if(key=="space") then
        if(status=="Menu") then
            status="Playing"
            bird.status="Move"
        else
            bird:space_pressed()
        end
        
    end

    if(key=="escape") then
        love.event.quit()
    end

    if(key=="r") then
        if(status=="Stop") then
            status="Playing"
            texter.status="None"
            bird:restart()
            counter:restart()
            prev_count=0

            for i=0, number_of_pipes do

                    pipes[i].passed=false
                    pipes[i].position.x=width+i*500
                    pipes[i].position.y=love.math.random(150, height-texture_bottom_height-150)
                    pipes[i].speed=speed

            end

            for i=0, number_of_backgrounds do
                backgrounds[i].speed=2
            end
        
            for i=0, number_of_bottoms do
                bottoms[i].speed=speed
                bottoms[i].status="Move"
            end

            timer=love.timer.getTime()
        end
    end
end
