Counter={}
Counter.__index=Counter

function Counter:create(width, height)
    local counter={}
    setmetatable(counter, Counter)
    counter.width=width
    counter.height=height
    counter.count=0
    counter.strcount="0"
    counter.numbers={["0"]=love.graphics.newImage("assets/sprites/0.png"),
                    ["1"]=love.graphics.newImage("assets/sprites/1.png"),
                    ["2"]=love.graphics.newImage("assets/sprites/2.png"),
                    ["3"]=love.graphics.newImage("assets/sprites/3.png"),
                    ["4"]=love.graphics.newImage("assets/sprites/4.png"),
                    ["5"]=love.graphics.newImage("assets/sprites/5.png"),
                    ["6"]=love.graphics.newImage("assets/sprites/6.png"),
                    ["7"]=love.graphics.newImage("assets/sprites/7.png"),
                    ["8"]=love.graphics.newImage("assets/sprites/8.png"),
                    ["9"]=love.graphics.newImage("assets/sprites/9.png")}
    counter.numberw=love.graphics.newImage("assets/sprites/0.png"):getWidth()
    return counter
end

function Counter:up()
    self.count=self.count+1
    self.strcount=tostring(self.count)
end

function Counter:restart()
    self.count=0
    self.strcount="0"
end

function Counter:draw()

    local ind=""
    local total_width=0

    for i=1,#self.strcount-1 do
        ind=self.strcount:sub(i,i)
        if(self.numbers[ind]~=nil) then
            total_width=total_width+self.numbers[ind]:getWidth()
        end
    end

    total_width=total_width/2
    local prev_width=0

    for i=1,#self.strcount do
        ind=self.strcount:sub(i,i)
        if(self.numbers[ind]~=nil) then
            love.graphics.draw(self.numbers[ind],width/2-total_width+prev_width,100)
            prev_width=prev_width+self.numbers[ind]:getWidth()
        end
    end
    
end