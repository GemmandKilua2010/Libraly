local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local SOUND_ID = "rbxassetid://0000000000"
local START_SOUND_ID = ""
local FINISH_SOUND_ID = ""

local LOAD_TIME = 5

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpecterXLoading"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local Window = Instance.new("Frame")
Window.Name = "LoadingWindow"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.fromScale(0.5, 0.5)
Window.Size = UDim2.fromOffset(520, 210)
Window.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Window.BorderSizePixel = 0
Window.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Window

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(40, 40, 46)
Stroke.Transparency = 0.35
Stroke.Thickness = 1
Stroke.Parent = Window

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(28, 24)
Title.Size = UDim2.new(1, -56, 0, 38)
Title.Text = "SPECTERX"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 27
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Window

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(28, 65)
Status.Size = UDim2.new(1, -56, 0, 25)
Status.Text = "Carregando..."
Status.TextColor3 = Color3.fromRGB(150, 150, 155)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Window

local BarBackground = Instance.new("Frame")
BarBackground.Position = UDim2.fromOffset(28, 110)
BarBackground.Size = UDim2.new(1, -56, 0, 8)
BarBackground.BackgroundColor3 = Color3.fromRGB(34, 34, 39)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = Window

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local Bar = Instance.new("Frame")
Bar.Size = UDim2.fromScale(0, 1)
Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Bar.BorderSizePixel = 0
Bar.Parent = BarBackground

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = Bar

local Percentage = Instance.new("TextLabel")
Percentage.BackgroundTransparency = 1
Percentage.Position = UDim2.fromOffset(28, 130)
Percentage.Size = UDim2.new(1, -56, 0, 25)
Percentage.Text = "0%"
Percentage.TextColor3 = Color3.fromRGB(120, 120, 126)
Percentage.TextSize = 12
Percentage.Font = Enum.Font.GothamMedium
Percentage.TextXAlignment = Enum.TextXAlignment.Right
Percentage.Parent = Window

local Footer = Instance.new("TextLabel")
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.fromOffset(28, 163)
Footer.Size = UDim2.new(1, -56, 0, 20)
Footer.Text = "SPECTERX SYSTEM"
Footer.TextColor3 = Color3.fromRGB(65, 65, 72)
Footer.TextSize = 9
Footer.Font = Enum.Font.GothamMedium
Footer.TextXAlignment = Enum.TextXAlignment.Left
Footer.Parent = Window

local function CreateSound(Name, SoundId, Volume)
	if SoundId == "" then
		return nil
	end

	local Sound = Instance.new("Sound")
	Sound.Name = Name
	Sound.SoundId = SoundId
	Sound.Volume = Volume or 0.5
	Sound.Parent = ScreenGui

	return Sound
end

local StartSound = CreateSound("StartSound", START_SOUND_ID, 0.5)
local LoadingSound = CreateSound("LoadingSound", SOUND_ID, 0.25)
local FinishSound = CreateSound("FinishSound", FINISH_SOUND_ID, 0.6)

if StartSound then
	StartSound:Play()
end

if LoadingSound then
	LoadingSound:Play()
end

local Tween = TweenService:Create(
	Bar,
	TweenInfo.new(
		LOAD_TIME,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	),
	{
		Size = UDim2.fromScale(1, 1)
	}
)

Tween:Play()

local StartTime = os.clock()

while true do
	local Progress = math.clamp(
		(os.clock() - StartTime) / LOAD_TIME,
		0,
		1
	)

	local Percent = math.floor(Progress * 100)

	Percentage.Text = Percent .. "%"

	if Percent < 25 then
		Status.Text = "Inicializando..."
	elseif Percent < 50 then
		Status.Text = "Carregando recursos..."
	elseif Percent < 75 then
		Status.Text = "Preparando sistema..."
	elseif Percent < 95 then
		Status.Text = "Finalizando..."
	else
		Status.Text = "Quase pronto..."
	end

	if Progress >= 1 then
		break
	end

	task.wait()
end

Percentage.Text = "100%"
Status.Text = "Carregamento concluído"
Footer.Text = "READY"

if LoadingSound then
	LoadingSound:Stop()
end

if FinishSound then
	FinishSound:Play()
end

task.wait(0.8)

local FadeInfo = TweenInfo.new(
	0.6,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

for _, Object in ipairs(Window:GetDescendants()) do
	if Object:IsA("TextLabel") then
		TweenService:Create(
			Object,
			FadeInfo,
			{
				TextTransparency = 1
			}
		):Play()

	elseif Object:IsA("Frame") then
		TweenService:Create(
			Object,
			FadeInfo,
			{
				BackgroundTransparency = 1
			}
		):Play()

	elseif Object:IsA("UIStroke") then
		TweenService:Create(
			Object,
			FadeInfo,
			{
				Transparency = 1
			}
		):Play()
	end
end

TweenService:Create(
	Window,
	FadeInfo,
	{
		BackgroundTransparency = 1
	}
):Play()

task.wait(0.7)

ScreenGui:Destroy()
