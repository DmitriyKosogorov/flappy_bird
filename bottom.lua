Bottom={}
Bottom.__index=Bottom

function Bottom:create(x,y,width, height,speed)
    local bottom={}
    setmetatable(bottom, Bottom)
    bottom.texture=love.graphics.newImage("assets/sprites/base.png")
    bottom.position=Vector:create(x,y)
    bottom.width=width
    bottom.height=height
    bottom.speed=speed
    bottom.status="Move"
    return bottom
end

function Bottom:update(status)
    if(status == "Stop") then
        self.status="Stop"
    end
    if(self.status=="Move") then
        self.position.x=self.position.x-self.speed
    end
end

function Bottom:draw()
    love.graphics.draw(self.texture,self.position.x, self.position.y,0,1)
end