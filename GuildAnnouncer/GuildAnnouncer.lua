--------------------------------------------------------------------------------
--  GuildAnnouncer (c) 2012 by Siarkowy
--  Released under the terms of GNU GPL v3 license.
--------------------------------------------------------------------------------
--  CHANGELOG
--
--  1.1
--      Added %p variable that holds player name for use in messages.
--      Added message presence check.
--
--  1.0
--      Initial version.
--------------------------------------------------------------------------------

local time = time

GuildAnnouncer = { }
local Ann = GuildAnnouncer
local frame

function Ann:Printf(...)
    DEFAULT_CHAT_FRAME:AddMessage(format(...))
end

function Ann:Init()
    frame = CreateFrame("frame")

    frame:SetScript("OnEvent", function(frame, event, ...) self[event](self, ...) end)
    frame:RegisterEvent("GUILD_ROSTER_UPDATE")
    frame:RegisterEvent("VARIABLES_LOADED")

    self.frame = frame
end

do
    local throttle = 1
    local timer = 0
    function Ann.OnUpdate(frame, elapsed)
        timer = timer + elapsed
        if timer >= throttle then
            timer = 0
            Ann:Check()
        end
    end
end

function Ann:GUILD_ROSTER_UPDATE()
    local interval, message = GetGuildInfoText():match("{gann:(%d+):(.-)}")
    if not interval then return end
    local db = self.db
    db.interval = tonumber(interval)
    db.message = message:trim()
    self:Update()
end

function Ann:VARIABLES_LOADED()
    GuildAnnDB = GuildAnnDB or {
        enabled = nil,
        interval = 3600,
        message = nil,
    }

    self.db = GuildAnnDB
    self:Update()
end

function Ann:Check()
    local db = self.db
    if time() % db.interval == 0 and db.message and IsInGuild() then
        SendChatMessage(".guild ann " .. db.message:gsub("%%p", UnitName("player")), "OFFICER")
    end
end

function Ann:Toggle(flag)
    frame:SetScript("OnUpdate", flag and self.OnUpdate or nil)
end

function Ann:Update()
    self:Toggle(self.db.enabled)
end

Ann:Init()

function Ann:OnSlash(msg)
    local cmd, param = msg:match("%s*(%S+)%s*(.*)%s*")

    if cmd == "interval" then self.db.interval = tonumber(param) or 3600
    elseif cmd == "message" then self.db.message = param:trim()
    elseif cmd == "off" then self.db.enabled = nil; self:Update()
    elseif cmd == "on" then self.db.enabled = true; self:Update()
    else
        self:Printf("Guild Announcer v. %s currently %s.", GetAddOnMetadata("GuildAnnouncer", "Version"), self.db.enabled and "enabled" or "disabled")
        self:Printf("Interval set to %d seconds.", self.db.interval)
        if self.db.message then
            self:Printf("Message set to %q (%d chars).", self.db.message, self.db.message:len())
        end
    end
end

SlashCmdList.GUILD_ANNOUNCER = function(msg) Ann:OnSlash(msg) end
SLASH_GUILD_ANNOUNCER1 = "/gann"
