local AddonName, Addon = ...

function Addon:InitThemes()
    if IPMTTheme == nil then
        IPMTTheme = {
            [1] = {}
        }
        -- convert params from prev 1.1.x and 1.2.x
        if IPMTOptions and IPMTOptions.font then
            IPMTTheme[1] = {
                font = IPMTOptions.font,
                main = {
                    size = {
                        w = IPMTOptions.size[0],
                        h = IPMTOptions.size[1],
                    },
                    background = {
                        color = {r=0, g=0, b=0, a=IPMTOptions.opacity},
                    },
                },
                elements = {},
                decors = {},
            }
            for frame, info in pairs(IPMTOptions.frame) do
                IPMTTheme[1].elements[frame] = {}
                if info.fontSize then 
                    IPMTTheme[1].elements[frame].fontSize = info.fontSize
                end
                if info.hidden then 
                    IPMTTheme[1].elements[frame].hidden = info.hidden
                end
            end
        else
            IPMTTheme = {
                [1] = {}
            }
        end
    end

    for themeID, theme in ipairs(IPMTTheme) do
        local decors = theme.decors
        if IPMTTheme[themeID].main.border.inset then -- convert old format
            IPMTTheme[themeID].main.background.inset = IPMTTheme[themeID].main.border.inset
        end
        IPMTTheme[themeID] = Addon:CopyObject(Addon.theme[1], IPMTTheme[themeID])
        if decors ~= nil and #decors then
            for decorID, info in ipairs(decors) do
                if info.border.inset then -- convert old format
                    info.background.inset = info.border.inset
                end
                IPMTTheme[themeID].decors[decorID] = Addon:CopyObject(Addon.defaultDecor, info)
            end
        end
    end
end

function Addon:ToggleThemeEditor()
    if Addon.opened.themes then
        Addon:CloseThemeEditor()
    else
        Addon:ShowThemeEditor()
    end
end

local optionsSize = {
    collapsed = {
        w = 0,
        h = 0,
    },
    expanded = {
        w = 0,
        h = 0,
    },
}
function Addon:ShowThemeEditor()
    Addon.opened.themes = true
    if Addon.fThemes == nil then
        Addon:RenderThemeEditor()
    end
    if optionsSize.collapsed.w == 0 then
        optionsSize.collapsed.w = Addon.fOptions:GetWidth()
        optionsSize.collapsed.h = Addon.fOptions:GetHeight()

        optionsSize.expanded.w = optionsSize.collapsed.w + Addon.fThemes:GetWidth() + 28
        optionsSize.expanded.h = max(optionsSize.collapsed.h, 600)
         
    end
    Addon.fOptions:SetSize(optionsSize.expanded.w, optionsSize.expanded.h)
    Addon.fOptions.editTheme.fTexture:SetVertexColor(1, 1, 1)
    Addon.fOptions.editTheme:SetBackdropColor(.25,.25,.25, 1)

    Addon:FillDummy()
    Addon:FillThemeEditor()
    Addon.fThemes:Show()
end

function Addon:CloseThemeEditor()
    if Addon.fThemes == nil then
        return
    end
    Addon.opened.themes = false
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fOptions:SetSize(optionsSize.collapsed.w, optionsSize.collapsed.h)
    Addon.fOptions.editTheme:SetBackdropColor(.175,.175,.175, 1)
    Addon.fThemes:Hide()
    for frame,info in pairs(theme.elements) do
        Addon:ToggleMovable(frame, false)
        if info.hidden then
            Addon.fMain[frame]:Hide()
        elseif IPMTDungeon.keyActive and frame == 'deathTimer' then
            Addon.deaths:Update()
        end
    end
    for decorID, info in ipairs(theme.decors) do
        Addon:ToggleMovable(decorID, false)
    end
    Addon:CloseElemEditor()
    Addon.fOptions.editTheme:OnLeave()
end

function Addon:FillDummy()
    local theme = IPMTTheme[IPMTOptions.theme]
    for i, info in ipairs(Addon.frames) do
        local frame = info.label
        if info.hasText and info.dummy ~= nil then
            if not IPMTDungeon.keyActive or Addon.fMain[frame].text:GetText() == nil then
                local text = info.dummy.text
                if frame == "progress" or frame == "prognosis" then
                    text = text[IPMTOptions.progress]
                end
                Addon.fMain[frame].text:SetText(text)
                Addon.fMain[frame]:Show()
                if info.dummy.colorId then
                    local color = theme.elements[frame].color[info.dummy.colorId]
                    Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
                end
            end
        end
    end

    if not IPMTDungeon.keyActive then
        local name, description, filedataid = C_ChallengeMode.GetAffixInfo(117) -- Reaping icon
        for i = 1,4 do
            SetPortraitToTexture(Addon.fMain.affix[i].Portrait, filedataid)
            Addon.fMain.affix[i]:Show()
        end
    end
end

function Addon:FillThemeEditor()
    local theme = IPMTTheme[IPMTOptions.theme]
    Addon.fThemes.name:SetText(theme.name)

    Addon.fThemes.fFonts:SelectItem(theme.font, true)
    Addon.fThemes.fFonts.fText:SetFont(theme.font, 12)

    Addon.fThemes.bg.width:SetText(theme.main.size.w)
    Addon.fThemes.bg.height:SetText(theme.main.size.h)
    Addon.fThemes.bg.background:SetText(theme.main.background.texture)
    Addon.fThemes.bg.backgroundColor:ColorChange(theme.main.background.color.r, theme.main.background.color.g, theme.main.background.color.b, theme.main.background.color.a, true)
    Addon.fThemes.bg.backgroundInset:SetValue(theme.main.background.inset)
    Addon.fThemes.bg.border:SetText(theme.main.border.texture)
    Addon.fThemes.bg.borderColor:ColorChange(theme.main.border.color.r, theme.main.border.color.g, theme.main.border.color.b, theme.main.border.color.a, true)
    Addon.fThemes.bg.borderSize:SetValue(theme.main.border.size)

    for frame, info in pairs(theme.elements) do
        Addon.fMain[frame]:Show()
        Addon:ToggleVisible(frame, true)
        if info.fontSize ~= nil then
            Addon.fThemes[frame].fontSize:SetValue(info.fontSize)
        end
        if info.justifyH ~= nil then
            Addon.fThemes[frame].justifyH:SelectItem(info.justifyH, true)
        end
        if info.color ~= nil then
            if info.color.r ~= nil then
                Addon.fThemes[frame].color[-1]:ColorChange(info.color.r, info.color.g, info.color.b, info.color.a, true)
            else
                for i, color in pairs(info.color) do
                    Addon.fThemes[frame].color[i]:ColorChange(color.r, color.g, color.b, color.a, true)
                end
            end
        end
    end
    for decorID, info in ipairs(theme.decors) do
        Addon:RenderDecorEditor(decorID)
        Addon:ToggleVisible(decorID, true)
    end
    for decorID = #theme.decors+1, #Addon.fThemes.decors do
        if Addon.fThemes.decors[decorID] ~= nil then
            Addon.fThemes.decors[decorID]:Hide()
        end
    end
    if #theme.decors == 0 then
        Addon:RecalcThemesHeight()
    end
end

function Addon:SetThemeName(name)
    IPMTTheme[IPMTOptions.theme].name = name
    Addon.fOptions.theme:SelectItem(IPMTOptions.theme, true)
end

function Addon:ToggleVisible(frame, woSave)
    local element
    local elemInfo
    local editorElement
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[frame]
        editorElement = Addon.fThemes.decors[frame]
    else
        element = Addon.fMain[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
        editorElement = Addon.fThemes[frame]
    end
    if woSave ~= true then
        elemInfo.hidden = not elemInfo.hidden
    end

    if type(frame) == "number" then
        if elemInfo.hidden then
            element:Hide()
        else
            element:Show()
        end
    else
        if elemInfo.hidden then
            element:SetBackdropColor(.85,0,0, .35)
        else
            local alpha = .15
            if woSave == true then
                alpha = 0
            end
            element:SetBackdropColor(1,1,1, alpha)
        end
    end
    if elemInfo.hidden then
        alpha = editorElement.toggle.icon:GetAlpha()
        editorElement.toggle.icon:SetVertexColor(.85, 0, 0, alpha)
        editorElement.toggle.icon:SetTexCoord(.25, .5, 0, .5)
    else
        editorElement.toggle.icon:SetTexCoord(0, .25, 0, .5)
        alpha = editorElement.toggle.icon:GetAlpha()
        editorElement.toggle.icon:SetVertexColor(1, 1, 1, alpha)
    end
end
function Addon:HoverVisible(frame, button)
    button.icon:SetAlpha(.9)
    local text
    local element
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[frame]
    else
        element = Addon.fMain[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    end
    if element.hidden then
        text = Addon.localization.ELEMACTION.SHOW
    else
        text = Addon.localization.ELEMACTION.HIDE
    end
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(text, .9, .9, 0, 1, true)
    GameTooltip:Show()
    if type(frame) ~= "number" then
        Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
    end
end
function Addon:BlurVisible(frame, button)
    button.icon:SetAlpha(.5)
    GameTooltip:Hide()
end

function Addon:ChangeDecor(decorID, params, woSave)
    local element
    local elemInfo
    if decorID == "main" then
        element = Addon.fMain
        elemInfo = IPMTTheme[IPMTOptions.theme].main
    else
        element = Addon.fMain.decors[decorID]
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[decorID]
    end

    if params.size then
        if params.size.w ~= nil then
            element:SetWidth(params.size.w)
            if woSave ~= true then
                elemInfo.size.w = params.size.w
            end
        end
        if params.size.h ~= nil then
            element:SetHeight(params.size.h)
            if woSave ~= true then
                elemInfo.size.h = params.size.h
            end
        end
    end

    if params.background then
        if params.background.texture ~= nil then
            element.background:SetTexture(params.background.texture)
            if woSave ~= true then
                elemInfo.background.texture = params.background.texture
            end
        end
        if params.background.color ~= nil then
            element.background:SetVertexColor(params.background.color.r, params.background.color.g, params.background.color.b, params.background.color.a)
            if woSave ~= true then
                elemInfo.background.color = Addon:CopyObject(params.background.color)
            end
        end
        if params.background.texSize ~= nil and woSave ~= true then
            elemInfo.background.texSize = Addon:CopyObject(params.background.texSize)
        end
        if params.background.coords ~= nil then
            element.background:SetTexCoord(params.background.coords[1], params.background.coords[2], params.background.coords[3], params.background.coords[4])
            if woSave ~= true then
                elemInfo.background.coords = Addon:CopyObject(params.background.coords)
            end
        end
        if params.background.inset then
            element.background:ClearAllPoints()
            element.background:SetPoint("TOPLEFT", element, "TOPLEFT", params.background.inset, -params.background.inset)
            element.background:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -params.background.inset, params.background.inset)
            if woSave ~= true then
                elemInfo.background.inset = params.background.inset
            end
        end
    end

    if params.border then 
        if params.border.color ~= nil then
            element:SetBackdropBorderColor(params.border.color.r, params.border.color.g, params.border.color.b, params.border.color.a)
            if woSave ~= true then
                elemInfo.border.color = Addon:CopyObject(params.border.color)
            end
        end
        if params.border.texture ~= nil or params.border.size ~= nil then
            local backdrop = {
                bgFile   = nil,
                edgeFile = elemInfo.border.texture,
                tile     = false,
                edgeSize = elemInfo.border.size,
            }
            if params.border.texture ~= nil then
                backdrop.edgeFile = params.border.texture
                if woSave ~= true then
                    elemInfo.border.texture = params.border.texture
                end
            end
            if params.border.size ~= nil then
                backdrop.edgeSize = params.border.size
                if woSave ~= true then
                    elemInfo.border.size = params.border.size
                end
            end
            if backdrop.edgeFile == 'none' then
                backdrop.edgeFile = nil
            end
            element:SetBackdrop(backdrop)
        end
    end
end

local function RecalcElem(frame)
    local oldText = Addon.fMain[frame].text:GetText()
    local checkText
    for i, info in ipairs(Addon.frames) do
        if info.label == frame then
            checkText = info.dummy.checker
        end 
    end

    Addon.fMain[frame].text:SetSize(150, 60)
    if checkText then
        Addon.fMain[frame].text:SetText(checkText)
    end
    local width = Addon.fMain[frame].text:GetStringWidth() + 4
    local height = Addon.fMain[frame].text:GetStringHeight()
    Addon.fMain[frame]:SetSize(width, height)
    Addon.fMain[frame].text:SetSize(width, height)
    if checkText then
        Addon.fMain[frame].text:SetText(oldText)
    end
end

function Addon:SetFont(filepath, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    for i, info in ipairs(Addon.frames) do
        local frameName = info.label
        local elemInfo = theme.elements[frameName]
        if frameName == Addon.season.frameName then
            if Addon.season.SetFont then
                Addon.season:SetFont(filepath, elemInfo.fontSize)
            end
        elseif info.hasText then
            Addon.fMain[frameName].text:SetFont(filepath, elemInfo.fontSize)
            if frameName ~= "dungeonname" then
                RecalcElem(frameName)
            end
        end
    end
    if woSave ~= true then
        theme.font = filepath
    end
end

function Addon:SetFontSize(frame, value, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if frame == Addon.season.frameName then
        if Addon.season.SetFont then
            Addon.season:SetFont(theme.font, value)
        end
    else
        Addon.fMain[frame].text:SetFont(theme.font, value)
        if frame ~= "dungeonname" then
            RecalcElem(frame)
        end
    end
    if woSave ~= true then
        theme.elements[frame].fontSize = value
    end
end

function Addon:SetColor(frame, color, i, woSave)
    local theme = IPMTTheme[IPMTOptions.theme]
    if frame == Addon.season.frameName then
        if Addon.season.SetColor then
            Addon.season:SetColor(color, i)
        end
    else
        Addon.fMain[frame].text:SetTextColor(color.r, color.g, color.b)
        Addon.fMain[frame].text:SetAlpha(color.a)
    end
    if woSave ~= true then
        local elemInfo = theme.elements[frame]
        if elemInfo.color.r ~= nil then
            elemInfo.color = Addon:CopyObject(color)
        else
            elemInfo.color[i] = Addon:CopyObject(color)
        end
    end
end

function Addon:SetIconSize(frame, value, woSave)
    if frame == Addon.season.frameName then
        if Addon.season.SetIconSize then
            Addon.season:SetIconSize(value)
        end
    else
        Addon.fMain[frame]:SetSize(value*4 + 10, value + 10)
        for f = 1,4 do
            local right = (-1) * (value + 1) * (f-1)
            Addon.fMain.affix[f]:SetSize(value, value)
            Addon.fMain.affix[f].Portrait:SetSize(value, value - 2)
            Addon.fMain.affix[f]:SetPoint("RIGHT", Addon.fMain.affixes, "RIGHT", right - 4, 0)
        end
    end

    if woSave ~= true then
        IPMTTheme[IPMTOptions.theme].elements[frame].iconSize = value
    end
end

-- Movable element
function Addon:ToggleMovable(frame, enable)
    local element
    local editorElement
    local elemInfo
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
        editorElement = Addon.fThemes.decors[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[frame]
    else
        element = Addon.fMain[frame]
        editorElement = Addon.fThemes[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    end

    if enable == nil then
        enable = not element.isMovable
    end
    element.isMovable = enable
    if element.isMovable then
        if type(frame) ~= "number" then
            element:SetBackdropColor(1,1,1, .25)
        end
        editorElement.moveMode.icon:SetAlpha(1)
        editorElement.moveMode.icon:SetScale(1.2)
    else
        if type(frame) ~= "number" then
            if elemInfo.hidden then
                element:SetBackdropColor(.85,0,0, .15)
            else
                local alpha = .15
                if not Addon.opened.themes then
                    alpha = 0
                end
                element:SetBackdropColor(1,1,1, alpha)
            end
        end
        local alpha = editorElement.moveMode.icon:GetAlpha()
        if alpha == 1 then
            alpha = .9
        else
            alpha = .5
        end
        editorElement.moveMode.icon:SetAlpha(alpha)
        editorElement.moveMode.icon:SetScale(1)
    end
    element:EnableMouse(element.isMovable)
    element:SetMovable(element.isMovable)
    if frame == 'affixes' then
        for f = 1,4 do
            Addon.fMain.affix[f]:EnableMouse(not Addon.fMain[frame].isMovable)
        end
    end
end
function Addon:HoverMovable(frame, button)
    local element
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
    else
        element = Addon.fMain[frame]
    end
    if not element.isMovable then
        button.icon:SetAlpha(.9)
    end
    local text
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(Addon.localization.ELEMACTION.MOVE, .9, .9, 0, 1, true)
    GameTooltip:Show()
    if type(frame) ~= "number" then
        Addon.fThemes[frame]:GetScript("OnEnter")(Addon.fThemes[frame])
    end
end
function Addon:BlurMovable(frame, button)
    local element
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
    else
        element = Addon.fMain[frame]
    end
    if not element.isMovable then
        button.icon:SetAlpha(.5)
    end
    GameTooltip:Hide()
end

function Addon:MoveElement(frame, params, woSave)
    local element
    local elemInfo
    if type(frame) == "number" then
        element = Addon.fMain.decors[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].decors[frame]
    else
        element = Addon.fMain[frame]
        elemInfo = IPMTTheme[IPMTOptions.theme].elements[frame]
    end

    if params == nil then
        params = elemInfo.position
    else
        if params.point == nil then
            params.point = elemInfo.position.point
        end
        if params.rPoint == nil then
            params.rPoint = elemInfo.position.rPoint
        end
        if params.x == nil then
            params.x = elemInfo.position.x
        end
        if params.y == nil then
            params.y = elemInfo.position.y
        end
    end
    element:ClearAllPoints()
    element:SetPoint(params.point, Addon.fMain, params.rPoint, params.x, params.y)

    if woSave ~= true then
        elemInfo.position.x = params.x
        elemInfo.position.y = params.y
        elemInfo.position.point = params.point
        elemInfo.position.rPoint = params.rPoint
    end
end

function Addon:SmartMoveElement(self, frame)
    local x = self:GetLeft() - Addon.fMain:GetLeft()
    local y = self:GetTop() - Addon.fMain:GetTop() - self:GetHeight() / 2
    local point = "LEFT"
    local rPoint
    if x > Addon.fMain:GetWidth() / 2 then
        point = "RIGHT"
        x = self:GetRight() - Addon.fMain:GetRight()
    end
    if y < Addon.fMain:GetHeight() / -2 then
        rPoint = "BOTTOM" .. point
        y = self:GetBottom() - Addon.fMain:GetBottom() + self:GetHeight() / 2
    else
        rPoint = "TOP" .. point
    end
    Addon:MoveElement(frame, {
        point = point,
        rPoint = rPoint,
        x = x,
        y = y,
    })
end

function Addon:AddDecor()
    local theme = IPMTTheme[IPMTOptions.theme]

    local decorID = #theme.decors + 1
    theme.decors[decorID] = Addon:CopyObject(Addon.defaultDecor)
    Addon:RenderDecor(decorID)
    Addon:RenderDecorEditor(decorID)
end

function Addon:RemoveDecor(decorID)
    local theme = IPMTTheme[IPMTOptions.theme]
    local lastID = #theme.decors
    for i = decorID,lastID do
        if theme.decors[i+1] ~= nil then
            theme.decors[i] = theme.decors[i+1]
            Addon:RenderDecorEditor(i)
            Addon:RenderDecor(i)
        end
    end
    theme.decors[lastID] = nil
    Addon.fMain.decors[lastID]:Hide()
    Addon.fThemes.decors[lastID]:Hide()

    Addon:RecalcThemesHeight()
end
function Addon:HoverDecor(decorID, button)
    button.icon:SetAlpha(.9)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(Addon.localization.DELETDECOR, .9, .9, 0, 1, true)
    GameTooltip:Show()
end
function Addon:BlurDecor(decorID, button)
    button.icon:SetAlpha(.5)
    GameTooltip:Hide()
end

function Addon:SetLayer(decorID, value, woSave)
    Addon.fMain.decors[decorID]:SetFrameLevel(value)
    if woSave ~= true then
        IPMTTheme[IPMTOptions.theme].decors[decorID].layer = value
    end
end
function Addon:SetJustifyH(frame, value, woSave)
    Addon.fMain[frame].text:SetJustifyH(value)
    if woSave ~= true then
        IPMTTheme[IPMTOptions.theme].elements[frame].justifyH = value
    end
end