# HadesSliderLib-WIP-
A WIP for making lua slide sliders available
# Creating
	CreateSlider(screen, {
  Name = "BoonSlider" .. 1, 
  Group = "Combat_Menu", 
  ShowSlider = true, 
  ItemAmount = 100, 
  StartingFraction = 1, 
  ItemWidth = 3, 
  Scale = {ButtonsX = 0.01249999999, ButtonsY = 0.25, ImageX = 0.75, ImageY = 1.25}, 
  X = itemLocationX, Y = itemLocationY, 
  SliderOffsetX = 85})
 A sample slider that will be seperated into 100 slices, screen must be the screen it is being created in
# Issues 
  The main problem right now is that the slider only goes to an element after leving your mouse on it for a second, it then caches it and will instantly return their later. I can neither find the cache, nor figure out a way to force it to auto-cache the buttons 