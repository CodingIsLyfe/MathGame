-- MathGame

supportedOrientations(LANDSCAPE_ANY)
--displayMode(FULLSCREEN)

-- Use this function to perform your initial setup
function setup()
    lastProblem=""
    value=0
    right=0
    wrong=0
    create()
    noFill()
    noSmooth()
    noStroke()
    pushStyle()
  -- Sprites in variables  
    clearButton = "Project:clearButton"
    backspaceButton = "Project:backspaceButton"
    enterButton = "Project:enterButton"
    professor = "Project:professor"
    speechBubble = "Project:speechBubble"
    
  -- List of positions for the keypad
local pos = {vec2(-250,0),vec2(-150,0),vec2(-50,0),vec2(-250,-100),vec2(-150,-100),vec2(-50,-100),vec2(-250,-200),vec2(-150,-200),vec2(-50,-200)}
pos[0]=vec2(-150,-300)
    
buttons={}
for i=0,9 do
    buttons[i]={} 
    buttons[i].img="Project:button"..i
    buttons[i].pos=vec2(WIDTH/2,HEIGHT/2)+pos[i]
end
end

function create()    
    a,ans,str={},{},{}
    choice=math.random(4)
    c=math.random(4)
    for z=1,4 do
        if c==1 then    --  addition problem
            a[z]=vec2(math.random(99),math.random(99))
            str[z]=string.format("%d + %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x+a[z].y)
        elseif c==2 then    --  subtraction problem
            a1=math.random(99)
            a2=math.random(99)
            a[z]=vec2(math.max(a1,a2),math.min(a1,a2))  -- prevents negative answer
            str[z]=string.format("%d - %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x-a[z].y)
        elseif c==3 then    -- multiplication problem
            a[z]=vec2(math.random(99),math.random(99))
            str[z]=string.format("%d x %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x*a[z].y)
        elseif c==4 then    -- division problem
            a1=math.random(30)
            a2=math.random(50,99)//a1
            a[z]=vec2(a1*a2,a1) -- prevents decimal needed answers
            str[z]=string.format("%d / %d = ",a[z].x,a[z].y)
            ans[z]=a[z].x/a[z].y
        end        
    end
end


-- This function gets called once every frame
function touched(t)
    if t.state==ENDED then --wait for touch to end
        local touch=vec2(t.x,t.y)
        for i=0,9 do
            if touch:dist(buttons[i].pos)<75 then
                keyTouched=i
                value=value*10+i
                return
            end
        end
        if touch:dist(vec2(WIDTH/2-250,HEIGHT/2-300))<75 then   -- clear
            value=0
        elseif touch:dist(vec2(WIDTH/2-50,HEIGHT/2-300))<75 then    -- backspace
            value=value//10
        elseif touch:dist(vec2(WIDTH/2+50,HEIGHT/2+130))<75 then    -- enter
            -- compare value with answer then move 0 to value
            if value==ans[choice] then
                corr=true
                lastProblem=str[choice]..math.tointeger(ans[choice])
                create()
                right=right+1
            else
                wrong=wrong+1
                corr=false
                lastProblem=str[choice]..math.tointeger(ans[choice])
                create()
            end
            value=0
        end 
    end        
end

-- This function gets called once every frame
function draw()
    
    -- This sets a background  
    sprite("SpaceCute:Background", WIDTH/2, HEIGHT/2, 1024, 768)
    
    stroke(0, 0, 0, 255)
    strokeWidth(3)
    
    fill(255, 255, 255, 255)
    rect(WIDTH/2-300, HEIGHT/2-345,300,400)
    -- This displays the 0-9 keypad
    for i=0,9 do
        sprite(buttons[i].img,buttons[i].pos.x,buttons[i].pos.y,75)
    end
    
    -- This displays the backspace, clear button and enter button
    sprite(clearButton, WIDTH/2-250, HEIGHT/2-300, 75)
    sprite(backspaceButton, WIDTH/2-50, HEIGHT/2-300, 75)
    sprite(enterButton, WIDTH/2+50, HEIGHT/2+130, 75)
    
    -- This displays the "Right" and "Wrong" at the top of the screen and the increments 
    fill(0, 0, 0, 255)
    fontSize(48)
    text("Right "..right,WIDTH/2-100,HEIGHT-50) -- "Right 0" 
    text("Wrong "..wrong,WIDTH/2+100,HEIGHT-50) -- "Wrong 0"
    fill(255, 255, 255, 255)
    rect(WIDTH/2-300, HEIGHT/2+100, 300, 50) -- Input bar
    
    fill(0)
    text(value, WIDTH/2-150, HEIGHT/2+120)
    
    -- This displays the professor sprite and his speech bubble
    sprite(professor, WIDTH/2+225,HEIGHT/2-50, 350, 600)
    sprite(speechBubble, WIDTH/2+75, HEIGHT/2+225, 250, 150)
    
    fill(0, 0, 0, 255)
    text(str[choice],WIDTH/2+75,HEIGHT/2+230)
    -- this displays the last problem, green was right, red was wrong
    if corr then
        fill(0,255,0)
    else 
        fill(255, 0, 0, 255)
    end
    text(lastProblem,WIDTH/2+215,HEIGHT/2-350)
end