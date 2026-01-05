local module 							= {}

----------------------------------------
--//GUI
local thisGUI							= script.Parent.Parent.Parent
local mainFrame							= thisGUI.Frames.Intro

local frame1 							= mainFrame.Dots.D1
local frame2 							= mainFrame.Dots.D2
local frame3 							= mainFrame.Dots.D3
local frame4 							= mainFrame.Dots.D4
local frame5 							= mainFrame.Dots.D5

----------------------------------------
mainFrame.Visible						= true

task.spawn(function()
	wait(0.5)
	for i = 1,math.random(5,6) 			do
		frame1:TweenPosition(UDim2.new(0.16, 1, 0, 0), 'Out', 'Linear', '0.25')
		wait(0.3)

		frame1:TweenPosition(UDim2.new(0.16, 1, -0.5, 0), "Out", 'Linear', '0.25')
		wait(0.3)
	end

	frame1:TweenPosition(UDim2.new(0.16, 1, 0, 0), 'Out', 'Linear', '0.25')
	frame1.BackgroundColor3 			= Color3.new(0.99205, 0.605173, 0.291691)

	wait(0.3)
	for i = 1,math.random(5,6) 			do
		frame2:TweenPosition(UDim2.new(0.33, 1, 0, 0), 'Out', 'Linear', '0.25')
		wait(0.3)

		frame2:TweenPosition(UDim2.new(0.33, 1, -0.5, 0), "Out", 'Linear', '0.25')
		wait(0.3)
	end

	frame2:TweenPosition(UDim2.new(0.33, 1, 0, 0), 'Out', 'Linear', '0.25')
	frame2.BackgroundColor3 			= Color3.new(0.99205, 0.605173, 0.291691)

	wait(0.3)
	for i = 1,math.random(5,6) 			do
		frame3:TweenPosition(UDim2.new(0.5, 1, 0, 0), 'Out', 'Linear', '0.25')
		wait(0.3)

		frame3:TweenPosition(UDim2.new(0.5, 1, -0.5, 0), "Out", 'Linear', '0.25')
		wait(0.3)
	end

	frame3:TweenPosition(UDim2.new(0.5, 1, 0, 0), 'Out', 'Linear', '0.25')
	frame3.BackgroundColor3 			= Color3.new(0.99205, 0.605173, 0.291691)

	wait(0.3)
	for i = 1,math.random(5,6) 			do
		frame4:TweenPosition(UDim2.new(0.66, 1, 0, 0), 'Out', 'Linear', '0.25')
		wait(0.3)

		frame4:TweenPosition(UDim2.new(0.66, 1, -0.5, 0), "Out", 'Linear', '0.25')
		wait(0.3)
	end

	frame4:TweenPosition(UDim2.new(0.66, 1, 0, 0), 'Out', 'Linear', '0.25')
	frame4.BackgroundColor3 			= Color3.new(0.99205, 0.605173, 0.291691)

	wait(0.3)
	for i = 1,math.random(5,6) 			do
		frame5:TweenPosition(UDim2.new(0.83, 1, 0, 0), 'Out', 'Linear', '0.25')
		wait(0.3)

		frame5:TweenPosition(UDim2.new(0.83, 1, -0.5, 0), "Out", 'Linear', '0.25')
		wait(0.3)
	end

	frame5:TweenPosition(UDim2.new(0.83, 1, 0, 0), 'Out', 'Linear', '0.25')
	frame5.BackgroundColor3 			= Color3.new(0.99205, 0.605173, 0.291691)

	wait(0.3)

	mainFrame.Desc.Text 				= "Assets Loaded!"

	wait(3)
	for i = 1,100 						do
		mainFrame.Transparency  		= i/100
		mainFrame.Logo.ImageTransparency 	= i/100
		frame1.Transparency 			= i/100
		frame2.Transparency 			= i/100
		frame3.Transparency 			= i/100
		frame4.Transparency 			= i/100
		frame5.Transparency 			= i/100
		wait()
	end

	wait(1)

end)

-----------------------------
return module
