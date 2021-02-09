local buttonIdToScreen = {}
local currentButton = nil
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
        components[Name .. "Button" .. buttonIndex].pressedArgs = {sliderPercent = a + ( c / d), name = Name}

        buttonIdToScreen[components[Name .. "Button" .. buttonIndex].Id] = {screen = screen, button = components[Name .. "Button" .. buttonIndex]}
               
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
    end
    
end
testGlobal = nil
SaveIgnores["testGlobal"] = true
function UpdateSliderPercentage(screen, button)
    local components = screen.Components
    SetAnimationFrameTarget({ Name = "ShrineMeterBarFill", Fraction = button.pressedArgs.sliderPercent, DestinationId = components[button.pressedArgs.name .. "SliderImage"].Id, Instant = true})
end
OnMouseOver{"LevelUpPlus", function (triggerArgs)
    currentButton = buttonIdToScreen[triggerArgs.triggeredById].button
    checkSlider()
end}

function checkSlider()
    local screen =  buttonIdToScreen[currentButton.Id].screen
        local notifyName = "ScreenInput".. screen.Name
        local buttons = {}
        for k,v in ipairs(buttonIdToScreen) do
            table.insert(buttons, v.button.Id)
        end
        NotifyOnInteract({ Ids =buttons, Notify = notifyName })
        
        waitUntil(notifyName)

        UpdateSliderPercentage(screen, currentButton)     
end