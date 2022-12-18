local myName, me = ...
local L = me.L

ShowBiSDruid = {}

ShowBiSDruid["DRUIDBalance"] = L["DRUIDBalance"]
ShowBiSDruid["DRUIDFeral"] = L["DRUIDFeral"]
ShowBiSDruid["DRUIDGuardian"] = L["DRUIDGuardian"]
ShowBiSDruid["DRUIDRestoration"] = L["DRUIDRestoration"]

function ShowBiSDruidFrameOnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ShowBiSDruid" then
		self:UnregisterEvent("ADDON_LOADED")
		PaperDollFrame:HookScript("OnShow", function() ShowBiSDruidFrameUpdate(self) end)
	end
	if event == "SPELLS_CHANGED" and IsAddOnLoaded("ShowBiSDruid") then
		ShowBiSDruidFrameUpdate(self)
	end
end

function ShowBiSDruidFrameCreate(frame)
	if PaperDollFrame:IsVisible() then
		frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
						   edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
						   tile = true,
						   tileSize = 16,
						   edgeSize = 16, 
						   insets = {left = 1,
									 right = 1,
									 top = 1,
									 bottom = 1}}) 
		frame:SetBackdropColor(0, 0, 0, 1)
		frame:SetFrameStrata("TOOLTIP")
		frame:SetWidth(PaperDollFrame:GetWidth() - 50) 
		if frame == PaperDollFrame then
			frame:SetHeight(150)
		else
			frame:SetHeight(500) --High text
			frame:SetWidth(550) --Width text
		end
		ShowBiSDruidText:ClearAllPoints()
		ShowBiSDruidText:SetAllPoints(frame) 
		ShowBiSDruidText:SetJustifyH("CENTER")
		ShowBiSDruidText:SetJustifyV("CENTER")

		frame:SetPoint("BOTTOMRIGHT", PaperDollFrame, "TOPRIGHT",550,- 440) -- witdh x High Position
		frame:SetParent(PaperDollFrame)
		frame:Show()
--------------- Frame Move ---------------
		frame:RegisterForDrag("LeftButton","RightButton");
		frame:EnableMouse(true);
		frame:SetMovable(true);
		frame:SetScript("OnMouseDown",OnMouseDown);
		frame:SetScript("OnMouseUp",OnMouseUp);
		frame:SetScript("OnHide",OnHide);
--------------- Frame Move ---------------
		return true
	end
	return false
end

--------------- Frame Move ---------------
function OnMouseDown(self)
    self:StartMoving();
    self.isMoving = true;
    self.hasMoved = false;
end
function OnMouseUp(self)
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;
        self.hasMoved = true;
    end
end
 
function OnHide(self)       
    if ( self.isMoving ) then
        self:StopMovingOrSizing();
        self.isMoving = false;
    end
end
--------------- Frame Move ---------------

function GetSpecializationName(id)
	local spec = ""
	if id == 102 then 
		spec = "Balance"
	elseif id == 103 then 
		spec = "Feral"
	elseif id == 104 then 
		spec = "Guardian"
	elseif id == 105 then 
		spec = "Restoration"
	elseif id == 250 then 
	end
	return spec
end

function ShowBiSDruidFrameUpdate(frame)
	if ShowBiSDruidFrameCreate(frame) then
		local temp, class = UnitClass("player")
		local spec = GetSpecializationInfo(GetSpecialization())
		spec = GetSpecializationName(spec)
		local text = ShowBiSDruid[class .. spec];
		ShowBiSDruidText:SetText(text)
	end
end

local ShowBiSDruidFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate");
ShowBiSDruidText = ShowBiSDruidFrame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
ShowBiSDruidFrame:RegisterEvent("ADDON_LOADED")
ShowBiSDruidFrame:RegisterEvent("SPELLS_CHANGED")
ShowBiSDruidFrame:SetScript("OnEvent", ShowBiSDruidFrameOnEvent)
