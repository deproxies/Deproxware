--[[
  Made completely by deproxies <3
  had to re optimize i didnt realize i forgot to disconnect the loop LOL
  enjoy
]]
local functions = {
    enabled = true,
    showskeleton = false,
    showdistance = true,
    boxcolor = Color3.fromRGB(255, 255, 255),
    useteamcolor = false,
    showhealth = true,
    showname = true,
    usedisplayname = false,
    
    textTopColor = Color3.fromRGB(255, 255, 255),
    textBottomColor = Color3.fromRGB(255, 255, 255),
    
    namePosition = "Top",
    healthPosition = "Bottom",
    distancePosition = "Bottom",
    
    npcenabled = true,
    npcshowskeleton = true,
    npcshowdistance = true,
    npcpath = workspace,
    npccolor = Color3.fromRGB(255, 255, 0),
    npcshowhealth = true,
    npcshowname = true,
    
    itemsenabled = true,
    itemshowdistance = true,
    itemcolor = Color3.new(0, 1, 1),
    showitemname = true,
    useitemfilter = true,
    targetitems = {},
}

local active_conns = {}
local drawing_cache = {}

local skeleton_parts = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local function destroy_drawings(table_to_clean)
    for k, v in pairs(table_to_clean) do
        if type(v) == "table" then
            destroy_drawings(v)
        elseif v.Remove then
            pcall(function() v:Remove() end)
        end
        table_to_clean[k] = nil
    end
end

function functions:unload()
    for _, conn in pairs(active_conns) do
        if conn.Disconnect then pcall(function() conn:Disconnect() end) end
    end
    active_conns = {}
    destroy_drawings(drawing_cache)
end

local function draw_esp(obj, hum, isnpc, config, custom_player)
    local rs = game:GetService("RunService")
    local cam = workspace.CurrentCamera
    
    local id = obj:GetDebugId()
    if drawing_cache[id] then destroy_drawings(drawing_cache[id]) end

    local drawings = {
        box = Drawing.new("Square"),
        text_top = Drawing.new("Text"),
        text_bottom = Drawing.new("Text"),
        head_circle = Drawing.new("Circle"),
        skeleton = {}
    }
    
    drawings.text_top.Size = 16
    drawings.text_top.Center = true
    drawings.text_top.Outline = true
    drawings.text_top.OutlineColor = Color3.new(0, 0, 0)
    
    drawings.text_bottom.Size = 16
    drawings.text_bottom.Center = true
    drawings.text_bottom.Outline = true
    drawings.text_bottom.OutlineColor = Color3.new(0, 0, 0)
    
    for i = 1, #skeleton_parts do
        local line = Drawing.new("Line")
        line.Thickness = 1
        drawings.skeleton[i] = line
    end

    drawing_cache[id] = drawings

    local conn
    conn = rs.RenderStepped:Connect(function()
        if not obj or not obj.Parent or not hum or hum.Health <= 0 then
            destroy_drawings(drawings)
            drawing_cache[id] = nil
            if conn then conn:Disconnect() end
            return
        end

        local master_on = isnpc and config.npcenabled or config.enabled
        if not master_on then
            drawings.box.Visible = false
            drawings.text_top.Visible = false
            drawings.text_bottom.Visible = false
            drawings.head_circle.Visible = false
            for _, v in ipairs(drawings.skeleton) do v.Visible = false end
            return
        end

        local hrp = obj:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local top_pos, on_screen = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
        
        if on_screen then
            local bottom_pos = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, -3.5, 0))
            local dist = (cam.CFrame.Position - hrp.Position).Magnitude
            
            local h = math.abs(top_pos.Y - bottom_pos.Y)
            local w = h / 1.5
            
            local current_color = config.boxcolor
            if isnpc then
                current_color = config.npccolor
            else
                local p = custom_player or game:GetService("Players"):GetPlayerFromCharacter(obj)
                current_color = (config.useteamcolor and p and p.TeamColor) and p.TeamColor.Color or config.boxcolor
            end

            drawings.box.Size = Vector2.new(w, h)
            drawings.box.Position = Vector2.new(top_pos.X - w / 2, top_pos.Y)
            drawings.box.Color = current_color
            drawings.box.Visible = true

            local t_label, b_label = "", ""
            local show_n = isnpc and config.npcshowname or config.showname
            local show_h = isnpc and config.npcshowhealth or config.showhealth
            local show_d = isnpc and config.npcshowdistance or config.showdistance

            if show_n then
                local name = isnpc and obj.Name or (config.usedisplayname and custom_player.DisplayName or custom_player.Name)
                if (isnpc and config.npcnamePosition or config.namePosition) == "Top" then t_label = name else b_label = name end
            end

            if show_h then
                local h_text = "[" .. math.floor(hum.Health) .. "hp]"
                if (isnpc and config.npchealthPosition or config.healthPosition) == "Top" then 
                    t_label = (t_label == "") and h_text or t_label .. " " .. h_text
                else 
                    b_label = (b_label == "") and h_text or b_label .. " " .. h_text
                end
            end

            if show_d then
                local d_text = "[" .. math.floor(dist) .. "s]"
                if (isnpc and config.npcdistancePosition or config.distancePosition) == "Top" then 
                    t_label = (t_label == "") and d_text or t_label .. " " .. d_text
                else 
                    b_label = (b_label == "") and d_text or b_label .. " " .. d_text
                end
            end

            drawings.text_top.Text = t_label
            drawings.text_top.Position = Vector2.new(top_pos.X, top_pos.Y - 18)
            drawings.text_top.Color = config.textTopColor
            drawings.text_top.Visible = t_label ~= ""
            
            drawings.text_bottom.Text = b_label
            drawings.text_bottom.Position = Vector2.new(top_pos.X, bottom_pos.Y + 2)
            drawings.text_bottom.Color = config.textBottomColor
            drawings.text_bottom.Visible = b_label ~= ""

            local show_skel = isnpc and config.npcshowskeleton or config.showskeleton
            if show_skel then
                local head = obj:FindFirstChild("Head")
                if head then
                    local h_p, h_on = cam:WorldToViewportPoint(head.Position)
                    if h_on then
                        drawings.head_circle.Position = Vector2.new(h_p.X, h_p.Y)
                        drawings.head_circle.Radius = h / 8
                        drawings.head_circle.Color = current_color
                        drawings.head_circle.Visible = true
                    end
                end

                for i, con in ipairs(skeleton_parts) do
                    local p1, p2 = obj:FindFirstChild(con[1]), obj:FindFirstChild(con[2])
                    if p1 and p2 then
                        local pos1, on1 = cam:WorldToViewportPoint(p1.Position)
                        local pos2, on2 = cam:WorldToViewportPoint(p2.Position)
                        if on1 and on2 then
                            drawings.skeleton[i].From = Vector2.new(pos1.X, pos1.Y)
                            drawings.skeleton[i].To = Vector2.new(pos2.X, pos2.Y)
                            drawings.skeleton[i].Color = current_color
                            drawings.skeleton[i].Visible = true
                            continue
                        end
                    end
                    drawings.skeleton[i].Visible = false
                end
            else
                drawings.head_circle.Visible = false
                for _, v in ipairs(drawings.skeleton) do v.Visible = false end
            end
        else
            drawings.box.Visible = false
            drawings.text_top.Visible = false
            drawings.text_bottom.Visible = false
            drawings.head_circle.Visible = false
            for _, v in ipairs(drawings.skeleton) do v.Visible = false end
        end
    end)

    table.insert(active_conns, conn)
end

function functions:item_esp(obj, custom_name)
    local rs = game:GetService("RunService")
    local cam = workspace.CurrentCamera
    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true

    local conn
    conn = rs.RenderStepped:Connect(function()
        if not obj or not obj.Parent or not self.itemsenabled then
            name:Remove()
            if conn then conn:Disconnect() end
            return
        end

        local pos, on = cam:WorldToViewportPoint(obj.Position)
        if on then
            local label = self.showitemname and (custom_name or obj.Name) or ""
            if self.itemshowdistance then
                local dist = (cam.CFrame.Position - obj.Position).Magnitude
                label = label .. " [" .. math.floor(dist) .. "s]"
            end
            name.Text = label
            name.Position = Vector2.new(pos.X, pos.Y)
            name.Color = self.itemcolor
            name.Visible = true
        else
            name.Visible = false
        end
    end)
    table.insert(active_conns, conn)
end

function functions:esp(p, char)
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then draw_esp(char, hum, false, self, p) end
        return
    end

    p.CharacterAdded:Connect(function(c)
        local hum = c:WaitForChild("Humanoid", 10)
        if hum then draw_esp(c, hum, false, self, p) end
    end)
    if p.Character then
        local hum = p.Character:FindFirstChild("Humanoid")
        if hum then draw_esp(p.Character, hum, false, self, p) end
    end
end

function functions:npc_esp(model)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if hum then draw_esp(model, hum, true, self) end
end

function functions:track_items(folder, filter)
    if filter then self.targetitems = filter end
    
    local function process(v)
        if self.useitemfilter and not table.find(self.targetitems, v.Name) then return end
        local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
        if part then self:item_esp(part, v.Name) end
    end

    for _, v in pairs(folder:GetChildren()) do process(v) end
    folder.ChildAdded:Connect(process)
end

return functions
--[[
================================================================================
                                USAGE EXAMPLES
================================================================================

1. INITIALIZING THE LIBRARY:
   local functionlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/deproxies/Main/refs/heads/main/ESPLibrary.lua"))()

2. SETTING UP PLAYER ESP:
   for _, v in pairs(game:GetService("Players"):GetPlayers()) do
       if v ~= game:GetService("Players").LocalPlayer then functionlib:esp(v) end
   end
   game:GetService("Players").PlayerAdded:Connect(function(v) functionlib:esp(v) end)

3. SETTING UP CUSTOM CHARACTER ESP:
   -- If a game uses a separate model for the player instead of their real Character:
   -- functionlib:esp(PlayerInstance, CustomModelInstance)
   local target_player = game:GetService("Players"):FindFirstChild("deproxies")
   local custom_model = workspace.CustomCharacters:FindFirstChild("deproxies_model")
   functionlib:esp(target_player, custom_model)

4. SETTING UP NPC ESP:
   functionlib.npcpath = workspace.Enemies 
   for _, v in pairs(functionlib.npcpath:GetChildren()) do functionlib:npc_esp(v) end
   functionlib.npcpath.ChildAdded:Connect(function(v) functionlib:npc_esp(v) end)

5. SETTING UP ITEM ESP:
   functionlib:track_items(workspace.Drops, {"Keycard", "Medkit", "Secret Weapon"})

6. GUI TOGGLE EXAMPLES:
   functionlib.enabled = true/false         -- toggle players
   functionlib.showskeleton = true/false    -- toggle player skeletons
   functionlib.namePosition = "Top"         -- put name on "Top" or "Bottom"
   functionlib.npcenabled = true/false      -- toggle npcs
   functionlib.npcshowskeleton = true/false -- toggle npc skeletons
   functionlib.itemsenabled = true/false    -- toggle items
   functionlib.useitemfilter = true/false   -- toggle filtering items by name
   functionlib.showhealth = true/false      -- show player health
   functionlib.showname = true/false        -- show player names
   functionlib.useteamcolor = true/false    -- use team color
   functionlib.boxcolor = Color3.fromRGB(255, 255, 255)
================================================================================
]]
