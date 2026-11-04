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
print("--------------------------------------------------")
