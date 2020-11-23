if GetLocale() ~= "zhTW" then return end

local AddonName, Addon = ...

Addon.localization.BACKGROUND = "背景"
Addon.localization.BORDER     = "邊框"
Addon.localization.BRDERWIDTH = "邊框寬度"

Addon.localization.CLEANDBBT  = "清理數據庫"
Addon.localization.CLEANDBTT  = "清理插件內部怪物百分比基礎數據。\n" ..
                                "如果百分比計數器有錯誤這是有幫助的"
Addon.localization.CLOSE      = "關閉"
Addon.localization.COLOR      = "顏色"
Addon.localization.COLORDESCR = {
    TIMER = {
        [-1] = '計時器顏色（如果按鍵已指定）',
        [0]  = '計時器顏色（如果時間在+1範圍內）',
        [1]  = '計時器顏色（如果時間在+2範圍內）',
        [2]  = '計時器顏色（如果時間在+3範圍內）',
    },
    OBELISKS = {
        [-1] = '存活的方尖碑顏色',
        [0]  = '關閉的方尖碑顏色',
    },
}
Addon.localization.COPY       = "複製"
Addon.localization.CORRUPTED = {
    [161124] = "『英雄擊破者』爾格羅斯 (坦克殺手)",
    [161241] = "虛織者瑪希爾 (蜘蛛)",
    [161243] = "山姆雷克，混沌召喚者 (恐懼)",
    [161244] = "腐化者之血 (軟泥)",
}

Addon.localization.DAMAGE     = "傷害"
Addon.localization.DEFAULT    = "預設"
Addon.localization.DEATHCOUNT = "死亡人數"
Addon.localization.DEATHSHOW  = "點擊查看詳細訊息"
Addon.localization.DEATHTIME  = "損失時間"
Addon.localization.DIRECTION  = "進度變化"
Addon.localization.DIRECTIONS = {
    asc  = "升序 (0% -> 100%)",
    desc = "降序 (100% -> 0%)",
}
Addon.localization.DTHCAPTION = "死亡紀錄"

Addon.localization.ELEMENT    = {
    AFFIXES   = "啟動詞綴",
    BOSSES    = "首領",
    DEATHS    = "死亡人數",
    DUNGENAME = "地城名稱",
    LEVEL     = "鑰石等級",
    OBELISKS  = "方尖碑",
    PLUSLEVEL = "鑰石升級",
    PLUSTIMER = "降低鑰石升級的時間",
    PROGRESS  = "已擊殺小怪",
    PROGNOSIS = "擊殺拉怪後的百分比",
    TIMER     = "鑰石計時器",
}
Addon.localization.ELEMACTION =  {
    SHOW = "顯示元素",
    HIDE = "隱藏元素",
    MOVE = "移動元素",
}
Addon.localization.ELEMPOS    = "元素位置"

Addon.localization.FONT       = "字型"
Addon.localization.FONTSIZE   = "字體大小"

Addon.localization.HEIGHT     = "高度"
Addon.localization.HELP = {
    AFFIXES    = "啟用的詞綴",
    BOSSES     = "已擊殺首領",
    DEATHTIMER = "因死亡而浪費的時間",
    LEVEL      = "啟動鑰石等級",
    PLUSLEVEL  = "鑰石將如何隨著當前時間升級",
    PLUSTIMER  = "降鑰石等級進度的時間",
    PROGNOSIS  = "在擊殺拉的小怪後的進度",
    PROGRESS   = "已擊殺小怪",
    TIMER      = "剩餘的時間",
}

Addon.localization.ICONSIZE   = "圖示大小"

Addon.localization.MAPBUT     = "滑鼠左鍵（單擊）- 切換選項\n" ..
                                "滑鼠左鍵（拖動）- 移動按鈕"
Addon.localization.MAPBUTOPT  = "顯示/隱藏小地圖按鈕"
Addon.localization.MELEEATACK = "近戰攻擊"

Addon.localization.OPTIONS    = "選項"

Addon.localization.POINT      = "位置"
Addon.localization.PRECISEPOS = "右鍵單擊以精確定位"
Addon.localization.PROGFORMAT = {
    percent = "百分比 (100.00%)",
    forces  = "部隊 (300)",
}
Addon.localization.PROGRESS   = "進度格式"

Addon.localization.RELPOINT   = "相對位置"

Addon.localization.SCALE      = "縮放"
Addon.localization.SEASONOPTS = "賽季選項"
Addon.localization.SOURCE     = "資源"
Addon.localization.STARTINFO  = "iP Mythic Timer已載入。輸入 /ipmt 開啟選項。"

Addon.localization.TEXTURE    = "材質"
Addon.localization.TXTRINDENT = "材質縮排"
Addon.localization.THEME      = "主題"
Addon.localization.THEMEBUTNS = {
    DUPLICATE   = "當前主題重複",
    DELETE      = "刪除當前主題",
    RESTORE     = '恢復主題"' .. Addon.localization.DEFAULT .. '"並選擇它',
    OPENEDITOR  = "打開主題編輯器",
    CLOSEEDITOR = "關閉主題編輯器",
}
Addon.localization.THEMEDITOR = "編輯主題"
Addon.localization.THEMENAME  = "主題名稱"
Addon.localization.TIME       = "時間"
Addon.localization.TIMERCHCKP = "計時器檢查點"

Addon.localization.UNKNOWN    = "未知"

Addon.localization.WAVEALERT  = '每過20%警告'
Addon.localization.WIDTH      = "寬度"
Addon.localization.WHODIED    = "誰死了"
