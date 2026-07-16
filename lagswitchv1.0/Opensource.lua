local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local LAG_DURATION = 0.4
local LAG_INTENSITY = 50000
local BUTTON_SIZE = Vector2.new(80, 38)
local BUTTON_TRANSPARENCY = 0
local OUTLINE_THICKNESS = 3

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanLagButton"
screenGui.ResetOnSpawn = false
screenGui.Parent = coreGui

local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, BUTTON_SIZE.X, 0, BUTTON_SIZE.Y)
buttonContainer.Position = UDim2.new(0.5, -BUTTON_SIZE.X / 2, 0.8, -BUTTON_SIZE.Y / 2)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = screenGui

local button = Instance.new("TextButton")
button.Name = "lag"
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = BUTTON_TRANSPARENCY
button.Text = "LAGSWITCH"
button.Font = Enum.Font.ArialBold
button.TextSize = 13
button.TextColor3 = Color3.fromRGB(230, 82, 80)
button.TextStrokeTransparency = 0
button.TextStrokeColor3 = Color3.fromRGB(230, 82, 80)
button.TextXAlignment = Enum.TextXAlignment.Center
button.TextYAlignment = Enum.TextYAlignment.Center
button.AutoButtonColor = false
button.ClipsDescendants = true
button.Parent = buttonContainer

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.15, 0)
corner.Parent = button

local buttonOutline = Instance.new("UIStroke")
buttonOutline.Color = Color3.fromRGB(0, 0, 0)
buttonOutline.Thickness = OUTLINE_THICKNESS
buttonOutline.Transparency = 1
buttonOutline.Parent = button

local isDragging = false
local dragInput = nil
local isLagging = false
local activeLagConnection = nil
local holdStartTime = nil
local dragStartPos = Vector2.new()
local containerStartPos = UDim2.new()

button.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	if isDragging then
		return
	end

	holdStartTime = os.clock()
	isDragging = true
	dragInput = input

	dragStartPos = input.Position
	containerStartPos = buttonContainer.Position

	button.BackgroundColor3 = Color3.fromRGB(120,120,120)
	button.BackgroundTransparency = 0
end)

button.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end
	if not holdStartTime then
		return
	end
	local holdDuration = os.clock() - holdStartTime
	holdStartTime = nil
	if input ~= dragInput then
	return
end

isDragging = false
dragInput = nil

button.BackgroundColor3 = Color3.fromRGB(0,0,0)
button.BackgroundTransparency = 0
buttonOutline.Color = Color3.fromRGB(0,0,0)
	if holdDuration < 0.5 and not isLagging then
		isLagging = true
		button.Text = "LAGSWITCHING"
		button.TextColor3 = Color3.fromRGB(119, 254, 125)
             button.TextStrokeColor3 = Color3.fromRGB(119, 254, 125)
             button.TextSize = 10

		local startTime = os.clock()
		activeLagConnection = runService.RenderStepped:Connect(function()
			if os.clock() - startTime >= LAG_DURATION then
				if activeLagConnection then
					activeLagConnection:Disconnect()
					activeLagConnection = nil
				end
				isLagging = false
				button.Text = "LAGSWITCH"
				button.TextColor3 = Color3.fromRGB(230, 82, 80)
                          button.TextStrokeColor3 = Color3.fromRGB(230, 82, 80)
                           button.TextSize = 13
				return
			end
			for i = 1, LAG_INTENSITY do
				local x = math.random() * math.random() * math.random()
				for j = 1, 10 do
					x = x ^ math.random()
					x = math.sin(x) * math.cos(x) * math.tan(x)
				end
			end
		end)
	end
end)

userInputService.InputChanged:Connect(function(input)
	if input ~= dragInput then
		return
	end

	local delta = input.Position - dragStartPos

	buttonContainer.Position = UDim2.new(
		containerStartPos.X.Scale,
		containerStartPos.X.Offset + delta.X,
		containerStartPos.Y.Scale,
		containerStartPos.Y.Offset + delta.Y
	)
end)

screenGui.Enabled = true
button.Active = true
button.Selectable = true
