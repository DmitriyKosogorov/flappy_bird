Pipe={}
Pipe.__index=Pipe

function Pipe:create(x,y,width, height,speed,type)
    local pipe={}
    setmetatable(pipe, Pipe)
    pipe.texture=love.graphics.newImage("assets/sprites/pipe-green.png")
    pipe.speed=speed
    pipe.status="Move"
    pipe.type=type
    pipe.width=width
    pipe.height=height
    pipe.position=Vector:create(x,y)
    pipe.halfhole=100
    pipe.passed=false
    return pipe
end

function Pipe:update(status)
    if(self.status=="Move") then
        self.position.x=self.position.x-self.speed
    else
        self.status="Stop"
    end
end

function Pipe:check_boundaries(bird)
    if(self.status=="Move") then
        if(bird.position.x>self.position.x+self.texture:getWidth()-10 or bird.position.x+bird.animations[0]:getWidth()<self.position.x+10) then
            self.status=self.status
        else
            if(bird.position.y<self.position.y-self.halfhole or bird.position.y+bird.animations[0]:getHeight()>self.position.y+self.halfhole) then
                bird:crush()
            end
        end
    end
end

function Pipe:draw()
    love.graphics.draw(self.texture,self.position.x, self.position.y-self.halfhole,0,1,-1)
    love.graphics.draw(self.texture,self.position.x, self.position.y+self.halfhole,0,1,1)

    love.graphics.draw(self.texture,self.position.x, self.position.y-self.halfhole-2*self.texture:getHeight(),0,1,1)
    love.graphics.draw(self.texture,self.position.x, self.position.y+self.halfhole+2*self.texture:getHeight(),0,1,-1)
end