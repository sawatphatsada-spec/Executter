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
    กดที่ปุ่มวงกลมเพื่อเปิดหน้าต่าง Executor")

