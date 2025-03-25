-- // Aimbot Script for Left Alt - Continuous Aiming for Town Specific
-- Check for required Roblox services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Get the local player and camera
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local AimbotKeybind = Enum.KeyCode.LeftAlt
local AimbotEnabled = false
local CurrentTarget = nil

-- Function to find the player closest to the crosshair
local function GetClosestToCrosshair()
    local closestDistance = math.huge
    local target = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPosition, onScreen = Camera:WorldToScreenPoint(head.Position)

            if onScreen then
                local mousePosition = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude

                if distance < closestDistance then
                    closestDistance = distance
                    target = head
                end
            end
        end
    end

    return target
end

-- Function to aim at the target
local function AimAt(target)
    if target then
        local targetPosition = target.Position
        local cameraCFrame = Camera.CFrame
        local direction = (targetPosition - cameraCFrame.Position).Unit

        Camera.CFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + direction)
    end
end

-- Continuously aim at the target while AimbotEnabled is true
RunService.RenderStepped:Connect(function()
    if AimbotEnabled and CurrentTarget then
        AimAt(CurrentTarget)
    end
end)

-- Keybind logic for aimbot activation
UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end

    if input.KeyCode == AimbotKeybind then
        AimbotEnabled = true
        CurrentTarget = GetClosestToCrosshair()
    end
end)

UserInputService.InputEnded:Connect(function(input, isProcessed)
    if input.KeyCode == AimbotKeybind then
        AimbotEnabled = false
        CurrentTarget = nil
    end
end)

-- Debugging messages (Optional)
print("Aimbot script for Town loaded. Hold Left Alt to aim at the nearest player to the crosshair continuously.")
