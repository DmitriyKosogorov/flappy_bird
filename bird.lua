Bird={}
Bird.__index=Bird

function Bird:create(x,y,width, height)
    local bird={}
    setmetatable(bird, Bird)
    bird.speed=speed
    bird.status="Menu"
    bird.width=width
    bird.height=height
    bird.timer=love.timer.getTime()
    bird.animations={[0]=love.graphics.newImage("assets/sprites/yellowbird-downflap.png"),
                    [1]=love.graphics.newImage("assets/sprites/yellowbird-midflap.png"),
                    [2]=love.graphics.newImage("assets/sprites/yellowbird-upflap.png")}
    bird.animation_index=0
    bird.position=Vector:create(x,y)
    bird.savedPosition=Vector:create(x,y)
    bird.gravity=0.2
    bird.acc=0
    bird.wing_sound=love.audio.newSource("assets/audio/wing.wav", "static")
    bird.crash_sound=love.audio.newSource("assets/audio/hit.wav", "static")
    bird.fall_sound=love.audio.newSource("assets/audio/die.wav", "static")
    bird.angle=0
    return bird
end

function Bird:update()
        if(self.status=="Move" or self.status=="Crashed") then
            self.acc=self.acc+self.gravity
            self.position.y=self.position.y+self.acc
        end



        self.angle=self.acc*0.1
        if(self.angle>1.6) then
            self.angle=1.6
        end

        if(self.angle<-1.6) then
            self.angle=-1.6
        end

        if(self.position.y <=0) then
            self.position.y=0
            self:crush()
        end

        if(self.status=="Crashed" and self.position.y<400 and love.timer.getTime()-self.timer>0.2) then
            love.audio.play(self.fall_sound)
        end

        if(self.position.y>=600) then
            if(self.status == "Crashed" or self.status=="Lying") then
                self.status="Lying"
                self.gravity=0
                self.acc=0
                self.angle=1.6
            else
                self:crush()
            end
        end

    if(self.status=="Move" or self.status=="Menu") then
        if(love.timer.getTime()-self.timer>=0.2) then
            self.timer=love.timer.getTime()
            if(self.animation_index==2) then
                self.animation_index=0
            else
                self.animation_index=self.animation_index+1
            end
        end
    end

    --print(self.status)
end

function Bird:space_pressed()
    if(self.status=="Move") then
        self.animation_index=0
        --self.acc=self.acc-10
        self.acc=-5
        love.audio.play(self.wing_sound)
        self.timer=love.timer.getTime()
    end
end

function Bird:crush()

    self.acc=0
    love.audio.play(self.crash_sound)
    self.status="Crashed"
    self.timer=love.timer.getTime()
end

function Bird:restart()
    self.position.x=self.savedPosition.x
    self.position.y=self.savedPosition.y
    self.angle=0
    self.acc=0
    self.gravity=0.2
    self.status="Move"
end

function Bird:draw()
    love.graphics.draw(self.animations[self.animation_index],self.position.x, self.position.y,bird.angle,1)

    if(self.status=="Crashed" and love.timer.getTime()-self.timer<0.2) then
        r,g,b,a=love.graphics.getColor()
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle("fill", 0,0, self.width, self.height)
        love.graphics.setColor(r,g,b,a)
    end
    
end