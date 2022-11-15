Background={}
Background.__index=Background

function Background:create(x,y,width, height,speed)
    local background={}
    setmetatable(background, Background)
    background.texture_day=love.graphics.newImage("assets/sprites/background-day.png")
    background.speed=speed
    background.status="Move"
    background.width=width
    background.height=height
    background.position=Vector:create(x,y)
    return background
end

function Background:update(status)
    if(status == "Stop") then
        self.status="Stop"
    else
        self.position.x=self.position.x-self.speed
    end
end

function Background:draw()
    love.graphics.draw(self.texture_day,self.position.x, self.position.y,0,1,(self.height/self.texture_day:getHeight()),3)
end