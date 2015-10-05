HarvesterStatus = {
	saveAndLoadFunctionsOverwritten = false;
	hasMouseCursorActive = false;
	canScroll = false;
	fileFound = false;
	showWarning = true;
	debug = true;
	modDir = g_currentModDirectory;
	imgDir = g_currentModDirectory .. 'res/';
	
	version = "1.0";
	author = "darignac";
	scriptName = "harvesterstatus";
};

-- Transforms the given pixel value to the correct value for the game engine
local function pxToNormal(px, dimension)
	if dimension == 'x' then
		return (px / 1920);
	else
		return (px / 1080);
	end;
end;

function HarvesterStatus:toRGBA(r, g, b, a)
	return {r/255, g/255, b/255, a};
end;

local modItem = ModsUtil.findModItemByModName(HarvesterStatus.modName);
if modItem and modItem.version and modItem.author then
	HarvesterStatus.version, HarvesterStatus.author = modItem.version, modItem.author;
end;

-- main entry into the game...
addModEventListener(HarvesterStatus);

-- called after/while (?) the map is/was loaded
function HarvesterStatus:loadMap()
	if self.initialized then
		return;
	end;
	
	self.inputModifier = self:getKeyIdOfModifier(InputBinding.HARVESTER_STATUS_HUD);
	self.helpButtonText = g_i18n:getText('HARVESTER_STATUS_HUD_SHOW');
	
	self.gui = {
		width = pxToNormal(200, 'x');
		height = pxToNormal(100, 'y');
		horizontalPadding = pxToNormal(5, 'x');
		fontSize = pxToNormal(14, 'y');
	};
	
	local horizontalMargin = pxToNormal(16, 'x');
	self.gui.x1 = 1 - self.gui.width - horizontalMargin;
	self.gui.x2 = self.gui.x1 + self.gui.width;
	self.gui.y1 = pxToNormal(390, 'y');
	self.gui.y2 = self.gui.y1 + self.gui.height;
	
	local gfxPath = Utils.getFilename('white.png', HarvesterStatus.imgDir);
	self.gui.background = Overlay:new('hsBackground', gfxPath, self.gui.x1, self.gui.y1, self.gui.width, self.gui.height);
	
	self.initialized = true;
	print(('>>> HarvesterStatus v%s by %s loaded...'):format(HarvesterStatus.version, HarvesterStatus.author));
end;

function HarvesterStatus:deleteMap()
	self.initialized = false;
end;

function HarvesterStatus:update()
	if g_currentMission.paused or g_gui.currentGui ~= nil then
		return;
	end;

	if InputBinding.hasEvent(InputBinding.HARVESTER_STATUS_HUD) then
		self:setHudState(self:loopNumberSequence(self.gui.hudState + 1, HarvesterStatus.HUDSTATE_INTERACTIVE, HarvesterStatus.HUDSTATE_CLOSED));
	end;

	if g_currentMission.showHelpText and (self.inputModifier == nil or Input.isKeyPressed(self.inputModifier)) then
		g_currentMission:addHelpButtonText(self.helpButtonText, InputBinding.HARVESTER_STATUS_HUD);
	end;
end;

-- TODO: this is called over and over again, there needs to be some break condition
function HarvesterStatus:draw()
	local g = self.gui;
	
	-- render background
	g.background:render();
	
	-- render some text
	setTextColor(unpack(self:toRGBA(1, 1, 1, 1.0)));
	renderText(g.x1 + g.horizontalPadding, g.y1 + pxToNormal(70, 'y'), g.fontSize, 'XXXXXXXXXXXXXXX');
	
	-- this slows down the game as it is called over and over again, see above. have to fix display of the mod gui first
--	for idx, vehicle in pairs(g_currentMission.vehicles) do
		-- mower is not the right type!
--		if vehicle['typeName'] == 'mower_animated' then
--			for a, b in pairs(vehicle) do
--				print(('>>> %s: %s'):format(a, b));
--			end;
--		end;
--		for a, b in pairs(vehicle) do
--			print(('>>> %s: %s'):format(a, b));
--		end;
	end;
end;

function HarvesterStatus:getKeyIdOfModifier(binding)
	if InputBinding.actions[binding] == nil then
		return nil;
	end;
	if #(InputBinding.actions[binding].keys1) <= 1 then
		return nil;
	end;
	-- Check if first key in key-sequence is a modifier key (LSHIFT/RSHIFT/LCTRL/RCTRL/LALT/RALT)
	if Input.keyIdIsModifier[ InputBinding.actions[binding].keys1[1] ] then
		return InputBinding.actions[binding].keys1[1]; -- Return the keyId of the modifier key
	end;
	return nil;
end

function HarvesterStatus:mouseEvent(posX, posY, isDown, isUp, mouseButton)
  return;
end

function HarvesterStatus:keyEvent(unicode, sym, modifier, isDown)
  return;
end;