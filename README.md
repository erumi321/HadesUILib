# HadesSliderLib-WIP-
A WIP for making lua slide sliders available
# Creating
```lua
local mySlider = CreateSlider(screen, {
  Name = "BoonSlider" .. 1, 
  Group = "Combat_Menu", 
  ShowSlider = true, 
  ItemAmount = 100, 
  StartingFraction = 1, 
  ItemWidth = 3, 
  Scale = {ButtonsX = 0.01249999999, ButtonsY = 0.25, ImageX = 0.75, ImageY = 1.25}, 
  X = itemLocationX, Y = itemLocationY, 
  SliderOffsetX = 85})
```  
 A sample slider that will be seperated into 100 slices, screen must be the screen it is being created in
 mySlider is the id of the slider  
# Adding Events
using the above id you can add listeners to the slider
```lua
	thread(CreateSliderListener, mySlider, {
		AlwaysUpdate = false,
		onPass = false,
		eventIndex = "30",
		sliderEvent = "event1",
		sliderEventArgs = {}
	})
```  
this will run the function event1 which should look like
```lua
function event1(sliderProgress, sliderEventArgs)
--stuff
end
```  
sliderProgress is a table looking like:
```lua
{
  index = 30,
  percentage = 0.3
}
```  
# Event Documentation
|Name|Description|
|---|---|
|AlwaysUpdate|If true, the eventIndex is disregarded and the function will be called whenever the slider is changed. Has priority over onPass|
|onPass|If true, if the change in the slider would go through that index, the function is called, with the values being passed the values of the button actually being pressed|
|eventIndex| Options: </br > `int`:the slider has to be pressed on exactly that button for the function to be called </br > `int1:int2`: the slider has to be pressed on any buttons between int1(inclusive) and int2(inclusive), the function will be passed the values ofthe actual button pressed</br >|
