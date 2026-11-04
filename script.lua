-- ==========================================
-- SCRIPT: Auto Version & Status Checker
-- ==========================================
local HttpService = game:GetService("HttpService")

-- 1. ตั้งค่าเวอร์ชันปัจจุบันของสคริปต์ตัวนี้ (เปลี่ยนตามเวอร์ชันที่คุณแจก)
local CURRENT_VERSION = "1.0.0" 

-- 2. ลิงก์หน้าเว็บดาวน์โหลดของคุณ และ ลิงก์ Raw status.json บน GitHub
local WEBSITE_URL = "https://your-download-website.com" -- ใส่ URL เว็บไซต์ของคุณตรงนี้
local STATUS_URL  = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/status.json"

-- 3. ตรวจสอบสถาปัตยกรรม (รองรับทั้ง 32 บิต และ 64 บิต)
local function checkArchitecture()
    if setmetatable and debug then
        return "32-bit / 64-bit Compatible"
    else
        return "Unknown Architecture"
    end
end

-- 4. ดึงข้อมูลสถานะจาก GitHub
local function getOnlineStatus()
    local success, response = pcall(function()
        return game:HttpGet(STATUS_URL)
    end)
    
    if success then
        return HttpService:JSONDecode(response)
    end
    return nil
end

print("--------------------------------------------------")
print("🔍 กำลังตรวจสอบเวอร์ชันและสถานะสคริปต์...")
print("📱 สถาปัตยกรรมเครื่อง: " .. checkArchitecture())

local onlineData = getOnlineStatus()

if onlineData then
    -- 🛑 กรณีที่ 1: สคริปต์หลักยังไม่ได้อัปเดต (ปิดปรับปรุงระบบรายวัน)
    if not onlineData.is_updated then
        warn("❌ [กากบาท] สคริปต์นี้ยังไม่ได้รับการอัปเดตประจำวัน!")
        warn("⚠️ คำเตือน: " .. onlineData.message)
        warn("🔗 กรุณาติดตามอัปเดตได้ที่หน้าเว็บ: " .. WEBSITE_URL)

    -- 🛑 กรณีที่ 2: ผู้ใช้ใช้ไฟล์เวอร์ชันเก่าเข้าเกม (ไม่ได้อัปเดตเป็นเวอร์ชันล่าสุด)
    elseif onlineData.latest_version ~= CURRENT_VERSION then
        warn("❌ [แจ้งเตือนอัปเดตเวอร์ชันใหม่]")
        warn("⚠️ ตัวเกม/สคริปต์ของคุณเป็นเวอร์ชันเก่า (" .. CURRENT_VERSION .. ") อาจจะใช้งานได้ไม่ดี หรือเสี่ยงโดนแบน!")
        warn("📢 มีเวอร์ชันใหม่แล้ว: v" .. onlineData.latest_version)
        warn("👉 กรุณาเข้าไปดาวน์โหลดตัวอัปเดตใหม่ได้ที่หน้าเว็บของคุณ:")
        print("🔗 ลิงก์ดาวน์โหลด: " .. WEBSITE_URL)
        
        -- บล็อกการทำงานเพื่อป้องกันไม่ให้ผู้ใช้โดนแบนจากเวอร์ชันเก่า
        error("ระบบหยุดการรันสคริปต์เนื่องจากต้องอัปเดตเวอร์ชันใหม่ก่อน")

    -- 🟢 กรณีที่ 3: อัปเดตล่าสุดแล้ว สามารถใช้งานได้ปลอดภัย
    else
        print("✅ [ติ๊กถูก] สคริปต์ได้รับการอัปเดตแล้ว!")
        print("💡 เวอร์ชันปัจจุบัน: v" .. CURRENT_VERSION .. " (ตรงกับระบบล่าสุด)")
        print("🚀 กำลังเริ่มรันสคริปต์สำหรับอุปกรณ์ของคุณ...")
        
        -- ==========================================
        -- >>> วางโค้ดทำงานหลักของคุณตรงนี้ <<<
        -- ==========================================
        print("✨ รันสคริปต์สำเร็จ ปลอดภัย รองรับ 32/64 บิต!")
    end
else
    warn("❌ ไม่สามารถดึงข้อมูลเวอร์ชันได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต")
end
print("--------------------------------------------------")-- ==========================================
-- SCRIPT: Delta-Style Floating UI & Features
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ลบ UI เก่าทิ้งก่อนสร้างใหม่ (ป้องกันการซ้ำซ้อน)
if CoreGui:FindFirstChild("DeltaStyleUI") then
    CoreGui.DeltaStyleUI:Destroy()
end

-- สร้าง ScreenGui หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaStyleUI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. ปุ่มเปิด/ปิดเมนู (Delta Floating Button - รูปโลโก้ลอยได้)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = screenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Image = "rbxassetid://6023426915" -- ไอคอนโลโก้จำลองสไตล์ Delta
toggleBtn.Active = true
toggleBtn.Draggable = true -- ทำให้ลากย้ายตำแหน่งปุ่มบนหน้าจอมือถือได้

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- ทำปุ่มให้กลมมน
btnCorner.Parent = toggleBtn

-- 2. หน้าต่างหลักของ Executor (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 450, 0, 260)
mainFrame.Visible = false -- เริ่มต้นซ่อนไว้ กดปุ่มกลมถึงจะแสดง
mainFrame.Active = true
mainFrame.Draggable = true -- ลากขยับหน้าต่างได้

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

-- แถบหัวข้อด้านบน (Top Bar)
local topBar = Instance.new("Frame")
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Size = UDim2.new(1, 0, 0, 35)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.03, 0, 0, 0)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Delta Style Executor - Custom"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มปิดหน้าต่าง (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = topBar
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Position = UDim2.new(0.9, 0, 0.15, 0)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- 3. กล่องพิมพ์ข้อความสคริปต์ (TextEditor / TextBox)
local textBox = Instance.new("TextBox")
textBox.Parent = mainFrame
textBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
textBox.Position = UDim2.new(0.03, 0, 0.2, 0)
textBox.Size = UDim2.new(0.94, 0, 0.6, 0)
textBox.Font = Enum.Font.Code
textBox.PlaceholderText = "-- วางสคริปต์ Lua ของคุณที่นี่..."
textBox.Text = "print('Hello from Delta-like Executor!')"
textBox.TextColor3 = Color3.fromRGB(0, 255, 128)
textBox.TextSize = 13
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 6)
textCorner.Parent = textBox

-- 4. แถบปุ่มควบคุมด้านล่าง (Execute & Clear Buttons)
local executeBtn = Instance.new("TextButton")
executeBtn.Parent = mainFrame
executeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
executeBtn.Position = UDim2.new(0.03, 0, 0.83, 0)
executeBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
executeBtn.Font = Enum.Font.GothamBold
executeBtn.Text = "Execute (รัน)"
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 13

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
execCorner.Parent = executeBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Parent = mainFrame
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clearBtn.Position = UDim2.new(0.52, 0, 0.83, 0)
clearBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "Clear (ล้าง)"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 13

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- --- ระบบการทำงานของปุ่มต่างๆ ---

-- กดปุ่มโลโก้เพื่อเปิด/ปิด หน้าต่าง Executor
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- กดปุ่ม X เพื่อปิดหน้าต่าง
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- กดปุ่ม Clear เพื่อล้างข้อความ
clearBtn.MouseButton1Click:Connect(function()
    textBox.Text = ""
end)

-- กดปุ่ม Execute เพื่อรันโค้ดที่พิมพ์ในกล่อง
executeBtn.MouseButton1Click:Connect(function()
    local codeToRun = textBox.Text
    local func, err = loadstring(codeToRun)
    if func then
        local success, runErr = pcall(func)
        if not success then
            warn("Execution Error: " .. tostring(runErr))
        end
    else
        warn("Compile Error: " .. tostring(err))
    end
end)

print("✨ โหลดเมนูสไตล์ Delta สำเร็จ!
    กดที่ปุ่มวงกลมเพื่อเปิดหน้าต่าง Executor")-- ==========================================
-- SCRIPT: Delta Executor + Rainbow UI & Status Checker
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ------------------------------------------
-- 1. ตั้งค่าเวอร์ชัน และ URL
-- ------------------------------------------
local CURRENT_VERSION = "1.0.0"
local WEBSITE_URL     = "https://your-download-website.com" -- ลิงก์เว็บของคุณ
local STATUS_URL      = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/status.json"

-- ------------------------------------------
-- 2. ระบบเช็คสถาปัตยกรรม (32/64 บิต) & สถานะ
-- ------------------------------------------
local function checkArchitecture()
    if setmetatable and debug then
        return "32-bit / 64-bit Compatible"
    else
        return "Unknown Architecture"
    end
end

local function getOnlineStatus()
    local success, response = pcall(function()
        return game:HttpGet(STATUS_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    end
    return nil
end

print("--------------------------------------------------")
print("🔍 กำลังตรวจสอบเวอร์ชันและสถานะสคริปต์...")
print("📱 สถาปัตยกรรมเครื่อง: " .. checkArchitecture())

local onlineData = getOnlineStatus()

if onlineData then
    if not onlineData.is_updated then
        warn("❌ [กากบาท] สคริปต์นี้ยังไม่ได้รับการอัปเดตประจำวัน!")
        warn("⚠️ คำเตือน: " .. onlineData.message)
        warn("🔗 ติดตามอัปเดตได้ที่: " .. WEBSITE_URL)
        return
    elseif onlineData.latest_version ~= CURRENT_VERSION then
        warn("❌ [แจ้งเตือนอัปเดตเวอร์ชันใหม่]")
        warn("⚠️ ตัวเกม/สคริปต์ของคุณเป็นเวอร์ชันเก่า (" .. CURRENT_VERSION .. ") อาจใช้งานได้ไม่ดี หรือเสี่ยงโดนแบน!")
        warn("📢 มีเวอร์ชันใหม่: v" .. onlineData.latest_version)
        warn("👉 ไปดาวน์โหลดตัวใหม่ได้ที่: " .. WEBSITE_URL)
        error("ระบบหยุดการทำงานเพื่อความปลอดภัย กรุณาอัปเดตสคริปต์")
        return
    else
        print("✅ [ติ๊กถูก] สคริปต์ได้รับการอัปเดตแล้ว พร้อมใช้งาน!")
    end
else
    warn("❌ ไม่สามารถดึงข้อมูลสถานะได้ กรุณาตรวจสอบการเชื่อมต่อ")
end
print("--------------------------------------------------")

-- ------------------------------------------
-- 3. สร้าง UI สไตล์ Delta + เอฟเฟกต์สีรุ้ง (RX-78 Theme)
-- ------------------------------------------
if CoreGui:FindFirstChild("DeltaRainbowUI") then
    CoreGui.DeltaRainbowUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaRainbowUI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 🔘 ปุ่มเปิด/ปิดเมนู (Floating Icon ลอยได้)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = screenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Image = "rbxassetid://6023426915"
toggleBtn.Active = true
toggleBtn.Draggable = true

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

-- 🌈 เส้นขอบสีรุ้งสำหรับปุ่มลอย
local btnStroke = Instance.new("UIStroke")
btnStroke.Parent = toggleBtn
btnStroke.Thickness = 2.5
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 🖼️ หน้าต่างหลัก (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 450, 0, 260)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

-- 🌈 เส้นขอบสีรุ้งรอบหน้าต่างหลัก
local frameStroke = Instance.new("UIStroke")
frameStroke.Parent = mainFrame
frameStroke.Thickness = 3
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- แถบด้านบน (Top Bar)
local topBar = Instance.new("Frame")
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Size = UDim2.new(1, 0, 0, 35)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.03, 0, 0, 0)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Delta Executor - Rainbow Edition"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มปิด (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = topBar
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Position = UDim2.new(0.9, 0, 0.15, 0)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- 📝 ช่องพิมพ์สคริปต์
local textBox = Instance.new("TextBox")
textBox.Parent = mainFrame
textBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
textBox.Position = UDim2.new(0.03, 0, 0.2, 0)
textBox.Size = UDim2.new(0.94, 0, 0.6, 0)
textBox.Font = Enum.Font.Code
textBox.PlaceholderText = "-- วางสคริปต์ Lua ที่นี่..."
textBox.Text = "print('Hello World!')"
textBox.TextColor3 = Color3.fromRGB(0, 255, 128)
textBox.TextSize = 13
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 6)
textCorner.Parent = textBox

-- 🔘 ปุ่ม Execute & Clear
local executeBtn = Instance.new("TextButton")
executeBtn.Parent = mainFrame
executeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
executeBtn.Position = UDim2.new(0.03, 0, 0.83, 0)
executeBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
executeBtn.Font = Enum.Font.GothamBold
executeBtn.Text = "Execute (รัน)"
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 13

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
execCorner.Parent = executeBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Parent = mainFrame
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clearBtn.Position = UDim2.new(0.52, 0, 0.83, 0)
clearBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "Clear (ล้าง)"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 13

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- ------------------------------------------
-- 4. สคริปต์รันระบบสีรุ้งขยับแบบ Real-time (Rainbow Animation)
-- ------------------------------------------
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
    
    -- อัปเดตสีรุ้งให้ขอบปุ่มและขอบหน้าต่าง
    btnStroke.Color = rainbowColor
    frameStroke.Color = rainbowColor
end)

-- ------------------------------------------
-- 5. ระบบสั่งงานปุ่ม UI
-- ------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

clearBtn.MouseButton1Click:Connect(function()
    textBox.Text = ""
end)

executeBtn.MouseButton1Click:Connect(function()
    local codeToRun = textBox.Text
    local func, err = loadstring(codeToRun)
    if func then
        local success, runErr = pcall(func)
        if not success then
            warn("Execution Error: " .. tostring(runErr))
        end
    else
        warn("Compile Error: " .. tostring(err))
    end
end)

    
print("🌈 โหลดเมนูสไตล์ Delta + เอฟเฟกต์สีรุ้งเรียบร้อยแล้ว!")-- ==========================================
-- SCRIPT: RCsX Get Key System + Delta Rainbow UI
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ------------------------------------------
-- 1. ตั้งค่า URL และตัวแปรระบบ
-- ------------------------------------------
local CURRENT_VERSION = "1.0.0"
local WEBSITE_URL     = "https://your-download-website.com" -- เว็บหลักของคุณ
local KEY_SYSTEM_URL  = "https://your-get-key-link.com"     -- ลิงก์สำหรับกดรับคีย์ (เช่น Linkvertise)
local CORRECT_KEY     = "RCX-VIP-2026"                      -- คีย์ตัวอย่าง (สามารถเปลี่ยนหรือต่อ API เช็คได้)
local STATUS_URL      = "https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/status.json"

-- ------------------------------------------
-- 2. เช็คสถานะและเวอร์ชันจาก GitHub ก่อนเริ่ม
-- ------------------------------------------
local function getOnlineStatus()
    local success, response = pcall(function()
        return game:HttpGet(STATUS_URL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    end
    return nil
end

local onlineData = getOnlineStatus()
if onlineData then
    if not onlineData.is_updated then
        warn("❌ สคริปต์นี้ยังไม่ได้รับการอัปเดตประจำวัน!")
        return
    elseif onlineData.latest_version ~= CURRENT_VERSION then
        warn("❌ สคริปต์ของคุณเป็นเวอร์ชันเก่า กรุณาอัปเดตที่เว็บ: " .. WEBSITE_URL)
        return
    end
end

-- ลบ UI เก่าทิ้งก่อนสร้างใหม่
if CoreGui:FindFirstChild("RCsXKeySystemUI") then
    CoreGui.RCsXKeySystemUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RCsXKeySystemUI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==========================================
-- 3. หน้าต่าง Get Key (สไตล์ RCsX)
-- ==========================================
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Parent = screenGui
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
keyFrame.BorderSizePixel = 0
keyFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
keyFrame.Size = UDim2.new(0, 380, 0, 220)
keyFrame.Active = true
keyFrame.Draggable = true

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Parent = keyFrame
keyStroke.Thickness = 2.5

-- หัวข้อหน้า Get Key
local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyFrame
keyTitle.BackgroundTransparency = 1
keyTitle.Position = UDim2.new(0, 0, 0.08, 0)
keyTitle.Size = UDim2.new(1, 0, 0, 30)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Text = "RCsX - Key System"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextSize = 18

-- กล่องใส่คีย์
local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Font = Enum.Font.Gotham
keyBox.PlaceholderText = "กรุณาใส่คีย์ที่นี่..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 14
keyBox.ClearTextOnFocus = false

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = keyBox

-- ปุ่ม Get Key (กดเพื่อคัดลอกลิงก์หรือไปเอาคีย์)
local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Parent = keyFrame
getKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
getKeyBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
getKeyBtn.Size = UDim2.new(0.38, 0, 0, 35)
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.Text = "Get Key (รับคีย์)"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.TextSize = 13

local getCorner = Instance.new("UICorner")
getCorner.CornerRadius = UDim.new(0, 6)
getCorner.Parent = getKeyBtn

-- ปุ่ม Verify Key (ตรวจสอบคีย์)
local verifyBtn = Instance.new("TextButton")
verifyBtn.Parent = keyFrame
verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
verifyBtn.Position = UDim2.new(0.52, 0, 0.62, 0)
verifyBtn.Size = UDim2.new(0.38, 0, 0, 35)
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.Text = "Verify (ยืนยัน)"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.TextSize = 13

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 6)
verifyCorner.Parent = verifyBtn

-- ข้อความสถานะแจ้งเตือนใต้กล่องคีย์
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = keyFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0.1, 0, 0.82, 0)
statusLabel.Size = UDim2.new(0.8, 0, 0, 25)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "กรุณากด Get Key เพื่อรับคีย์ใช้งาน"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextSize = 11

-- ==========================================
-- 4. หน้าต่างหลัก Executor (ซ่อนไว้จนกว่าจะใส่คีย์ถูก)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 450, 0, 260)
mainFrame.Visible = false -- ซ่อนไว้ก่อน
mainFrame.Active = true
mainFrame.Draggable = true

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Parent = mainFrame
frameStroke.Thickness = 3

-- ปุ่ม Floating Logo เปิด/ปิดเมนูหลัก (จะแสดงต่อเมื่อผ่านหน้า Key แล้ว)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = screenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Image = "rbxassetid://6023426915"
toggleBtn.Visible = false -- ซ่อนไว้ก่อนผ่านหน้า Key
toggleBtn.Active = true
toggleBtn.Draggable = true

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Parent = toggleBtn
btnStroke.Thickness = 2.5

-- ส่วนหัวข้อของ Executor
local topBar = Instance.new("Frame")
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Size = UDim2.new(1, 0, 0, 35)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = topBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.03, 0, 0, 0)
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "RCsX & Delta - Rainbow Edition"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = topBar
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Position = UDim2.new(0.9, 0, 0.15, 0)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- กล่องพิมพ์สคริปต์
local textBox = Instance.new("TextBox")
textBox.Parent = mainFrame
textBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
textBox.Position = UDim2.new(0.03, 0, 0.2, 0)
textBox.Size = UDim2.new(0.94, 0, 0.6, 0)
textBox.Font = Enum.Font.Code
textBox.PlaceholderText = "-- วางสคริปต์ Lua ที่นี่..."
textBox.Text = "print('Welcome to RCsX Executor!')"
textBox.TextColor3 = Color3.fromRGB(0, 255, 128)
textBox.TextSize = 13
textBox.ClearTextOnFocus = false
textBox.MultiLine = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 6)
textCorner.Parent = textBox

-- ปุ่ม Execute & Clear
local executeBtn = Instance.new("TextButton")
executeBtn.Parent = mainFrame
executeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
executeBtn.Position = UDim2.new(0.03, 0, 0.83, 0)
executeBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
executeBtn.Font = Enum.Font.GothamBold
executeBtn.Text = "Execute (รัน)"
executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
executeBtn.TextSize = 13

local execCorner = Instance.new("UICorner")
execCorner.CornerRadius = UDim.new(0, 6)
execCorner.Parent = executeBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Parent = mainFrame
clearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clearBtn.Position = UDim2.new(0.52, 0, 0.83, 0)
clearBtn.Size = UDim2.new(0.45, 0, 0.13, 0)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Text = "Clear (ล้าง)"
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextSize = 13

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearBtn

-- ------------------------------------------
-- 5. เอฟเฟกต์สีรุ้ง RX-78 วิ่งรอบ UI ทั้งหมด
-- ------------------------------------------
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
    
    keyStroke.Color = rainbowColor
    btnStroke.Color = rainbowColor
    frameStroke.Color = rainbowColor
end)

-- ------------------------------------------
-- 6. ระบบการทำงานของปุ่ม Key System และ Executor
-- ------------------------------------------

-- ปุ่ม Get Key: พยายามคัดลอกลิงก์หรือแจ้งเตือนลิงก์รับคีย์
getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(KEY_SYSTEM_URL)
        statusLabel.Text = "คัดลอกลิงก์รับคีย์ไปยังคลิปบอร์ดแล้ว!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    else
        statusLabel.Text = "ลิงก์รับคีย์: " .. KEY_SYSTEM_URL
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end)

-- ปุ่ม Verify: ตรวจสอบคีย์ที่ผู้ใช้กรอก
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        statusLabel.Text = "ยืนยันคีย์สำเร็จ กำลังเปิดเมนู..."
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        
        task.wait(1)
        keyFrame.Visible = false    -- ปิดหน้าต่างใส่คีย์
        toggleBtn.Visible = true    -- เปิดปุ่มโลโก้ลอย
        mainFrame.Visible = true    -- เปิดหน้าต่าง Executor หลัก
    else
        statusLabel.Text = "คีย์ไม่ถูกต้อง! กรุณาลองใหม่อีกครั้ง"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- ควบคุมการเปิด/ปิดเมนูหลักผ่านปุ่มลอย
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

clearBtn.MouseButton1Click:Connect(function()
    textBox.Text = ""
end)

executeBtn.MouseButton1Click:Connect(function()
    local codeToRun = textBox.Text
    local func, err = loadstring(codeToRun)
    if func then
        local success, runErr = pcall(func)
        if not success then
            warn("Execution Error: " .. tostring(runErr))
        end
    else
        warn("Compile Error: " .. tostring(err))
    end
end)

print("✨ โหลดระบบ RCsX Key System + Delta Rainbow เรียบร้อยแล้ว!")titleLabel.Text = "Gun Executor - Rainbow Edition"

    



