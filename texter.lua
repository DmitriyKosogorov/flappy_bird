Texter={}
Texter.__index=Texter

function Texter:create(width, height)
    local texter={}
    setmetatable(texter, Texter)
    texter.welcome=love.graphics.newImage("assets/sprites/message.png")
    texter.gameover=love.graphics.newImage("assets/sprites/gameover.png")
    texter.status="Welcome"
    texter.position=Vector:create((width-texter.welcome:getWidth()*2)/2,(height-texter.welcome:getHeight()*2))
    texter.opacity=1
    return texter
end

function Texter:update()
    if(self.status=="Welcomeout") then
        self.opacity=self.opacity-0.1
    end

    if(self.opacity<=0) then
        self.opacity=1
        self.status="None"
    end
    
    if(self.status=="Gameoverin") then
        if(self.position.x>=(width-texter.gameover:getWidth()*2)/2) then
            self.status="Gameover"
        else
            self.position.x=self.position.x+10
        end
    end
end

function Texter:draw()
    if(self.status=="Welcome" or self.status=="Welcomeout") then
        love.graphics.draw(self.welcome,self.position.x, self.position.y,0,2,self.opacity)
        r,g,b,a=love.graphics.getColor()
        love.graphics.setColor(0,0,0,1)
        love.graphics.print("Press [Space] to start and jump. [ESC] to exit",self.position.x-90, self.position.y+self.welcome:getHeight(),0,2,self.opacity)
        love.graphics.setColor(r,g,b,a)
    end
    if(self.status=="Gameoverin" or self.status=="Gameover") then
        love.graphics.draw(self.gameover,self.position.x, self.position.y,0,2)
        r,g,b,a=love.graphics.getColor()
        love.graphics.setColor(0,0,0,1)
        love.graphics.print("[R] to restart",self.position.x+110, self.position.y+120,0,2,self.opacity)
        love.graphics.setColor(r,g,b,a)
    end
end