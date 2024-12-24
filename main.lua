local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function createUIElement(type, properties, children)
    local element = Instance.new(type)
    for property, value in pairs(properties) do
        element[property] = value
    end
    for _, child in ipairs(children or {}) do
        child.Parent = element
    end
    return element
end

local function animate(element, properties, duration, easingStyle, easingDirection, callback)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quint, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    if callback then
        tween.Completed:Connect(callback)
    end
    return tween
end

local DarkThemeLibrary = {}

function DarkThemeLibrary:CreateUI(config)
    local ScreenGui = createUIElement("ScreenGui", {
        Name = config.Name or "DarkThemeLibrary",
        Parent = CoreGui
    })

    local MainFrame = createUIElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = config.Size or UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = config.BackgroundTransparency or 0.1,
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 10)
        })
    })

    -- Add Title Bar with Controls
    local TitleBar = createUIElement("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    }, {
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 10)
        })
    })

    createUIElement("ImageLabel", {
        Name = "AppIcon",
        Parent = TitleBar,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 5, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.AppIcon or "rbxassetid://12345678"
    })

    createUIElement("TextLabel", {
        Name = "AppName",
        Parent = TitleBar,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = config.AppName or "Application",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local CloseButton = createUIElement("TextButton", {
        Name = "CloseButton",
        Parent = TitleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16
    }, {
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 5)
        })
    })

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Add Tabs
    local TabContainer = createUIElement("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    })

    local TabContent = createUIElement("Frame", {
        Name = "TabContent",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    })

    local Tabs = {}
    function Tabs:AddTab(name, callback, icon)
        local TabButton = createUIElement("TextButton", {
            Name = name .. "Tab",
            Parent = TabContainer,
            Size = UDim2.new(0, 100, 0, 40),
            BackgroundTransparency = 1,
            Text = "",
        })

        local TabIcon = createUIElement("ImageLabel", {
            Name = "TabIcon",
            Parent = TabButton,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0.5, -10, 0.5, -10),
            BackgroundTransparency = 1,
            Image = icon or "rbxassetid://12345678"
        })

        local Underline = createUIElement("Frame", {
            Name = "Underline",
            Parent = TabButton,
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Visible = false
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:FindFirstChild("Underline").Visible = false
                end
            end
            Underline.Visible = true

            for _, child in ipairs(TabContent:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end

            local TabFrame = callback()
            TabFrame.Parent = TabContent
            TabFrame.Visible = true
        end)

        TabButton.MouseEnter:Connect(function()
            -- Tooltip Logic
            if config.TooltipEnabled then
                local Tooltip = createUIElement("TextLabel", {
                    Name = "Tooltip",
                    Parent = ScreenGui,
                    Size = UDim2.new(0, 100, 0, 25),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    Text = name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    BackgroundTransparency = 0.1
                }, {
                    createUIElement("UICorner", {
                        CornerRadius = UDim.new(0, 5)
                    })
                })
                Tooltip.Position = UDim2.new(0, game:GetService("UserInputService").GetMouseLocation.X, 0, game:GetService("UserInputService").GetMouseLocation.Y)
                TabButton.MouseLeave:Connect(function()
                    Tooltip:Destroy()
                end)
            end
        end)
    end

    return MainFrame, Tabs
end

function DarkThemeLibrary:CreateButton(config)
    local Button = createUIElement("TextButton", {
        Name = config.Name or "Button",
        Parent = config.Parent,
        Size = config.Size or UDim2.new(0, 200, 0, 50),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(40, 40, 40),
        Text = config.Text or "Button",
        TextColor3 = config.TextColor3 or Color3.fromRGB(255, 255, 255),
        Font = config.Font or Enum.Font.Gotham,
        TextSize = config.TextSize or 16,
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 8)
        })
    })

    Button.MouseEnter:Connect(function()
        animate(Button, {BackgroundColor3 = config.HoverColor or Color3.fromRGB(60, 60, 60)}, 0.2)
    end)

    Button.MouseLeave:Connect(function()
        animate(Button, {BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(40, 40, 40)}, 0.2)
    end)

    if config.OnClick then
        Button.MouseButton1Click:Connect(function()
            config.OnClick(Button)
        end)
    end

    return Button
end

function DarkThemeLibrary:AnimatePosition(element, newPosition, duration, easingStyle, easingDirection, callback)
    animate(element, {Position = newPosition}, duration or 0.5, easingStyle, easingDirection, callback)
end

function DarkThemeLibrary:AnimateSize(element, newSize, duration, easingStyle, easingDirection, callback)
    animate(element, {Size = newSize}, duration or 0.5, easingStyle, easingDirection, callback)
end

function DarkThemeLibrary:AnimateTransparency(element, transparency, duration, easingStyle, easingDirection, callback)
    animate(element, {BackgroundTransparency = transparency}, duration or 0.5, easingStyle, easingDirection, callback)
end

function DarkThemeLibrary:AnimateColor(element, newColor, duration, easingStyle, easingDirection, callback)
    animate(element, {BackgroundColor3 = newColor}, duration or 0.5, easingStyle, easingDirection, callback)
end

function DarkThemeLibrary:CustomAnimation(element, properties, duration, easingStyle, easingDirection, callback)
    animate(element, properties, duration or 0.5, easingStyle, easingDirection, callback)
end

return DarkThemeLibrary
