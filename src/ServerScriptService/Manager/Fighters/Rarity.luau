local module 						= {}

-----------------------------------
module.List 						= 
	{
		["Common"] 					= 		
		{	
			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 99, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))}),
			StrokeColor 			= Color3.fromRGB(0, 172, 0),
			Priority				= 6,
		},

		["Rare"] 					= 			
		{	
			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(1, 40, 112)), ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 87, 255))}),
			StrokeColor 			= Color3.fromRGB(2, 87, 255),
			Priority				= 5,
		},

		["Epic"] 					= 			
		{		
			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 1, 120)), ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 2, 255))}),
			StrokeColor 			= Color3.fromRGB(170, 1, 255),
			Priority				= 4,
		},

		["Legendary"] 				= 	
		{	

			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(117, 117, 1)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0))}),
			StrokeColor 			= Color3.fromRGB(255, 255, 0),
			Priority				= 3,
		},

		["Mythical"] 				= 		
		{		
			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 91, 121)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 252, 252))}),
			StrokeColor 			= Color3.fromRGB(0, 252, 252),
			Priority				= 2,
		},

		["Secret"] 					= 		
		{		
			Color 					= ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 0))}),
			StrokeColor 			= Color3.fromRGB(170, 0, 0),
			Priority				= 1,
		},
	}


-----------------------------------
return module
