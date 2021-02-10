SliderFunctionValues = {
    --[[Example item
    [sliderId] = {
        lastIndex = any int,
        ["AlwaysUpdate"] = {
            {
                eventIndex = blah, --Not needed
                FunctionName ="Blah Blah always 1"
                args = {}
            }
            {
                eventIndex = blah, --Not needed
                FunctionName ="Blah Blah always 2 now with args"
                args = {Blah = Blah Blah}
            }
        }
        ["onPass"] = {
            {
                eventIndex = "2",
                FunctionName ="Blah Blah when going past 2"
                args = {}
            }
        }
        ["exactResting"] = {
            {
                eventIndex = "57",
                FunctionName = "Blah Blah at exactly 57"
                args = {}
            }
            {
                eventIndex = "50:60",
                FunctionName = "Blah Blah inbetween 50 and 60"
                args = {Blah = Blah Blah}
            }
        }
    }
    All entries are optional:
        "AlwaysUpdate" option will run the function everytime the slider is updated
        "onPass" option is if the slider would go past it, instead of resting on it
        eventIndex is when slider goes on that value do something
        Not having something in onPass means that the option would have to be specifically selected
        X:Y is if the resting point is greater then or equal to X and less then or equal to Y (cant be put in onPass). 
            X must ALWAYS be less then then Y
        Functions are always passed the sliders currentValue and the args of the event, only valid function sytax is:
            function myFunction(currentValue, args)
            currentValue is the buttonIndex, not the percentage
        The variables can be named differently, of course
    ]]--
}
SaveIgnores["SliderFunctionValues"] = true
function CreateSlider(screen, args)
	local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedSlider")
  
    for buttonIndex = 1, (args.ItemAmount or 1) do
		components[Name .. "Button" .. buttonIndex] = CreateScreenComponent({ Name = "LevelUpPlus", Group = args.Group, Scale = 6, X = xPos, Y = yPos })
        components[Name .. "Button" .. buttonIndex].OnPressedFunctionName = "UpdateSliderPercentage"
        local a = ((buttonIndex - 0.5) / (args.ItemAmount or 1))
        local c = ((args.ItemWidth or 1) / 2)
        local d = ((args.ItemWidth or 1) * (args.ItemAmount or 1))
        components[Name .. "Button" .. buttonIndex].pressedArgs = {sliderPercent = a + ( c / d), name = Name, buttonIndex = buttonIndex}
               
        SetScaleX({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsX or 1) * 1.2 })
		SetScaleY({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsY or 1) * 0.8 })
        xPos = xPos + args.ItemWidth
    end
    if args.ShowSlider then
        components[Name .. "SliderImage"] = CreateScreenComponent({ Name = "ShrineMeterBarFill", Group = args.Group, Scale = 1, X = (args.X or 0) + 65 + (args.SliderOffsetX or 0), Y = (args.Y or 0) })
        --SetAnimation({ Name = "KeepsakeBarFill", DestinationId = components[Name .. "SliderImage"].Id, Scale = 1 })
        SetAnimationFrameTarget({ Name = "ShrineMeterBarFill", Fraction = args.StartingFraction or 1, DestinationId = components[Name .. "SliderImage"].Id, Instant = true})
        SetScaleX({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageX or 1)  })
        SetScaleY({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageY or 1) })
        SliderFunctionValues[components[Name .. "SliderImage"].Id] = {lastIndex = args.StartingFraction * args.ItemAmount}
        return components[Name .. "SliderImage"].Id
    end
    return -1
end
testGlobal = nil
SaveIgnores["testGlobal"] = true
function UpdateSliderPercentage(screen, button)
    local components = screen.Components
    SetAnimationFrameTarget({ Name = "ShrineMeterBarFill", Fraction = button.pressedArgs.sliderPercent, DestinationId = components[button.pressedArgs.name .. "SliderImage"].Id, Instant = true})
    local sliderId = components[button.pressedArgs.name .. "SliderImage"].Id
    DebugPrint({Text = sliderId})
    if SliderFunctionValues[sliderId]["AlwaysUpdate"] ~= nil then
        for k,v in ipairs(SliderFunctionValues[sliderId]["AlwaysUpdate"]) do
            DebugPrint({Text = "Always Update"})
            thread(_G[v.FunctionName],{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args)
        end
    end
    if SliderFunctionValues[sliderId]["onPass"] ~= nil then
        local lastIndex = SliderFunctionValues[sliderId].lastIndex
        for k,v in ipairs(SliderFunctionValues[sliderId]["onPass"]) do
            if lastIndex > button.pressedArgs.buttonIndex then
                if tonumber(v.eventIndex) >= button.pressedArgs.buttonIndex and tonumber(v.eventIndex) <= lastIndex then
                    DebugPrint({Text = "Passed Through"})
                    thread(_G[v.FunctionName],{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args)
                end
            elseif lastIndex < button.pressedArgs.buttonIndex then
                if tonumber(v.eventIndex) <= button.pressedArgs.buttonIndex and tonumber(v.eventIndex) >= lastIndex then
                    DebugPrint({Text = "Passed Through"})
                    thread(_G[v.FunctionName],{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args)
                end
            end
        end
    end
    if SliderFunctionValues[sliderId]["exactResting"] ~= nil then
        for k,v in ipairs(SliderFunctionValues[sliderId]["exactResting"]) do
            if string.find(v.eventIndex, ":") then
                local splitStr = mysplit(v.eventIndex, ":")
                if button.pressedArgs.buttonIndex > tonumber(splitStr[1]) and button.pressedArgs.buttonIndex < tonumber(splitStr[2]) then
                    DebugPrint({Text = "In-between"})
                    thread(_G[v.FunctionName],{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args)
                end
            elseif button.pressedArgs.buttonIndex == tonumber(v.eventIndex) then
                DebugPrint({Text = "Exact"})
                thread(_G[v.FunctionName],{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args)
            end
        end
    end
    SliderFunctionValues[sliderId].lastIndex = button.pressedArgs.buttonIndex

end

--[[Args should be
{
    AlwaysUpdate = true/false (default f)
    onPass = true/false (If both onPass and AlwaysUpdate are true, AlwaysUpdate will take priority) (default f)
    eventIndex = any string (this is when the event should occur) (default -1)
    sliderEvent = any string (the Function Name) (if nil this func will not do anything and imemdiatly stop )
    sliderEventArgs = any table (default empty Table)
}
]]
function CreateSliderListener(sliderId, args)
    if args.sliderEvent == nil then
        return
    end
    local isAlways = args.AlwaysUpdate
    local isOnPass = args.onPass
    local eventIndex = args.eventIndex
    local sliderEvent = args.sliderEvent
    local sliderEventArgs = args.sliderEventArgs
    local eventTable = {
        eventIndex = eventIndex,
        FunctionName = sliderEvent,
        args = sliderEventArgs
    }
    if isAlways then
        if SliderFunctionValues[sliderId]["AlwaysUpdate"] == nil then
            SliderFunctionValues[sliderId]["AlwaysUpdate"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["AlwaysUpdate"], eventTable)
    elseif isOnPass then
        if SliderFunctionValues[sliderId]["onPass"] == nil then
            SliderFunctionValues[sliderId]["onPass"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["onPass"], eventTable)
    else
        if SliderFunctionValues[sliderId]["exactResting"] == nil then
            SliderFunctionValues[sliderId]["exactResting"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["exactResting"], eventTable)
        --SliderFunctionValues[sliderId][eventIndex] = eventTable
    end
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end