local function NotifyPlayer(playerSource, messageType, message, duration)
    TriggerClientEvent('ia_preset_converter:client:ShowNotification', playerSource, messageType, message, duration)
end

local function ConvertQBToIllenium(qbData, currentTargetModel)
    if type(qbData) ~= "table" then return nil end
    local illeniumData = {}
    if qbData.model and qbData.model ~= "" then illeniumData.model = qbData.model
    elseif currentTargetModel and currentTargetModel ~= "" then illeniumData.model = currentTargetModel
    else
        if qbData.model and (string.find(string.lower(tostring(qbData.model)), "_m_") or string.find(string.lower(tostring(qbData.model)), "male")) then illeniumData.model = Config.DefaultMaleModel
        elseif qbData.model and (string.find(string.lower(tostring(qbData.model)), "_f_") or string.find(string.lower(tostring(qbData.model)), "female")) then illeniumData.model = Config.DefaultFemaleModel
        else illeniumData.model = Config.DefaultMaleModel end
    end
    if qbData.headBlend and type(qbData.headBlend) == "table" then illeniumData.headBlend = {shapeFirst = tonumber(qbData.headBlend.shapeFirst) or 0, shapeSecond = tonumber(qbData.headBlend.shapeSecond) or 0, shapeThird = tonumber(qbData.headBlend.shapeThird) or 0, skinFirst = tonumber(qbData.headBlend.skinFirst) or 0, skinSecond = tonumber(qbData.headBlend.skinSecond) or 0, skinThird = tonumber(qbData.headBlend.skinThird) or 0, shapeMix = tonumber(qbData.headBlend.shapeMix) or 0.0, skinMix = tonumber(qbData.headBlend.skinMix) or 0.0, thirdMix = tonumber(qbData.headBlend.thirdMix) or 0.0} end
    if qbData.hair and type(qbData.hair) == "table" then illeniumData.hair = {style = tonumber(qbData.hair.style), color = tonumber(qbData.hair.color), highlight = tonumber(qbData.hair.highlight), texture = tonumber(qbData.hair.texture)}; for k,v in pairs(illeniumData.hair) do if v == nil then illeniumData.hair[k] = 0 end end end
    if qbData.faceFeatures and type(qbData.faceFeatures) == "table" then illeniumData.faceFeatures = {}; for key, value in pairs(qbData.faceFeatures) do if Config.IlleniumStructureBase.faceFeatures[key] ~= nil then illeniumData.faceFeatures[key] = tonumber(value) or 0.0 end end; if next(illeniumData.faceFeatures) == nil then illeniumData.faceFeatures = nil end end
    if qbData.eyeColor ~= nil then illeniumData.eyeColor = tonumber(qbData.eyeColor) end
    if qbData.headOverlays and type(qbData.headOverlays) == "table" then illeniumData.headOverlays = {}; for overlayName, qbOverlayData in pairs(qbData.headOverlays) do if Config.IlleniumStructureBase.headOverlays[overlayName] then if type(qbOverlayData) == "table" then illeniumData.headOverlays[overlayName] = {style = tonumber(qbOverlayData.style), opacity = tonumber(qbOverlayData.opacity), color = tonumber(qbOverlayData.color), secondColor = tonumber(qbOverlayData.secondColor)}; for k,v_base in pairs(Config.IlleniumStructureBase.headOverlays[overlayName]) do if illeniumData.headOverlays[overlayName][k] == nil then illeniumData.headOverlays[overlayName][k] = v_base end end end end end; if next(illeniumData.headOverlays) == nil then illeniumData.headOverlays = nil end end
    if qbData.components and type(qbData.components) == "table" and #qbData.components > 0 then illeniumData.components = {}; for _, comp in ipairs(qbData.components) do if type(comp) == "table" and comp.component_id ~= nil and comp.drawable ~= nil and comp.texture ~= nil then table.insert(illeniumData.components, {component_id = tonumber(comp.component_id), drawable = tonumber(comp.drawable), texture = tonumber(comp.texture)}) end end; if #illeniumData.components == 0 then illeniumData.components = nil end end
    if qbData.props and type(qbData.props) == "table" and #qbData.props > 0 then illeniumData.props = {}; for _, prop in ipairs(qbData.props) do if type(prop) == "table" and prop.prop_id ~= nil and prop.drawable ~= nil and prop.texture ~= nil then table.insert(illeniumData.props, {prop_id = tonumber(prop.prop_id), drawable = tonumber(prop.drawable), texture = tonumber(prop.texture)}) end end; if #illeniumData.props == 0 then illeniumData.props = nil end end
    if qbData.tattoos and type(qbData.tattoos) == "table" and #qbData.tattoos > 0 then local zonedTattoos = {}; for _, tattooEntry in ipairs(qbData.tattoos) do if type(tattooEntry) == "table" then local zone = tattooEntry.zone or "ZONE_TORSO"; local collection = tattooEntry.collection; local overlayHash = tattooEntry.overlay or tattooEntry.nameHash or tattooEntry.tattooNameHash or tattooEntry.overlayHashMale or tattooEntry.overlayHashFemale; if collection and overlayHash then if not zonedTattoos[zone] then zonedTattoos[zone] = {} end; table.insert(zonedTattoos[zone], {collection = collection, overlay = overlayHash, opacity = tonumber(tattooEntry.opacity) or 1.0, hashMale = tattooEntry.hashMale or overlayHash, hashFemale = tattooEntry.hashFemale or overlayHash}) end end end; if next(zonedTattoos) then illeniumData.tattoos = zonedTattoos else illeniumData.tattoos = nil end end
    return illeniumData
end

local function ConvertNationToIllenium(nationData, currentTargetModel)
    if type(nationData) ~= "table" then return nil end
    local illeniumData = {}
    if nationData.gender == "female" then illeniumData.model = Config.DefaultFemaleModel
    elseif nationData.gender == "male" then illeniumData.model = Config.DefaultMaleModel
    elseif currentTargetModel and currentTargetModel ~= "" then illeniumData.model = currentTargetModel
    else illeniumData.model = Config.DefaultMaleModel end
    if nationData.shapeFirst ~= nil or nationData.skinFirst ~= nil then illeniumData.headBlend = {shapeFirst = tonumber(nationData.shapeFirst) or 0, shapeSecond = tonumber(nationData.shapeSecond) or 0, shapeThird = tonumber(nationData.shapeThird) or 0, skinFirst = tonumber(nationData.skinFirst) or 0, skinSecond = tonumber(nationData.skinSecond) or 0, skinThird = tonumber(nationData.skinThird) or 0, shapeMix = tonumber(nationData.shapeMix) or 0.0, skinMix = tonumber(nationData.skinMix) or 0.0, thirdMix = tonumber(nationData.thirdMix) or 0.0} end
    if nationData.hair ~= nil or nationData['hair-color'] ~= nil then illeniumData.hair = {style = tonumber(nationData.hair) or 0, color = tonumber(nationData['hair-color']) or 0, highlight = tonumber(nationData['hair-highlightcolor']) or 0, texture = 0} end
    illeniumData.faceFeatures = {}; local ffMap = Config.FaceFeatureMapNationToIllenium or {}; for nationKey, illKey in pairs(ffMap) do if nationData[nationKey] ~= nil and type(nationData[nationKey]) == "number" then illeniumData.faceFeatures[illKey] = tonumber(nationData[nationKey]) end end; if nationData.chinBoneWidth ~= nil and type(nationData.chinBoneWidth) == "number" then illeniumData.faceFeatures.chinBoneSize = tonumber(nationData.chinBoneWidth) end; if next(illeniumData.faceFeatures) == nil then illeniumData.faceFeatures = nil end
    if nationData.eyes ~= nil then illeniumData.eyeColor = tonumber(nationData.eyes) end
    illeniumData.headOverlays = {}; local overlayMap = Config.HeadOverlayMapIlleniumToNation or {}; for illOverlayName, nationKeys in pairs(overlayMap) do local style = nationData[nationKeys.styleKey]; local opacity = nationData[nationKeys.opacityKey]; local color = nationData[nationKeys.colorKey]; local secondColor = nationData[nationKeys.secondColorKey]; if style ~= nil or opacity ~= nil or color ~= nil then illeniumData.headOverlays[illOverlayName] = {style = (style ~= nil and tonumber(style)) or (Config.IlleniumStructureBase.headOverlays[illOverlayName] and Config.IlleniumStructureBase.headOverlays[illOverlayName].style or -1), opacity = (opacity ~= nil and tonumber(opacity)) or (Config.IlleniumStructureBase.headOverlays[illOverlayName] and Config.IlleniumStructureBase.headOverlays[illOverlayName].opacity or 0.0), color = (color ~= nil and tonumber(color)) or (Config.IlleniumStructureBase.headOverlays[illOverlayName] and Config.IlleniumStructureBase.headOverlays[illOverlayName].color or 0), secondColor = (secondColor ~= nil and tonumber(secondColor)) or (Config.IlleniumStructureBase.headOverlays[illOverlayName] and Config.IlleniumStructureBase.headOverlays[illOverlayName].secondColor or 0)} end end; if next(illeniumData.headOverlays) == nil then illeniumData.headOverlays = nil end
    if nationData.tattoos and type(nationData.tattoos) == "table" and #nationData.tattoos > 0 then local zonedTattoos = {}; for _, tattooEntry in ipairs(nationData.tattoos) do if type(tattooEntry) == "table" then local zone = tattooEntry.zone or "ZONE_TORSO"; local collection = tattooEntry.collection; local overlayHash = tattooEntry.overlay or tattooEntry.nameHash or tattooEntry.tattooNameHash or tattooEntry.overlayHashMale or tattooEntry.overlayHashFemale; if collection and overlayHash then if not zonedTattoos[zone] then zonedTattoos[zone] = {} end; table.insert(zonedTattoos[zone], {collection = collection, overlay = overlayHash, opacity = tonumber(tattooEntry.opacity) or 1.0, hashMale = tattooEntry.hashMale or overlayHash, hashFemale = tattooEntry.hashFemale or overlayHash}) end end end; if next(zonedTattoos) then illeniumData.tattoos = zonedTattoos else illeniumData.tattoos = nil end end
    return illeniumData
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Wait(500)
        TriggerClientEvent('ia_preset_converter:client:setInitialConfig', -1, Config.IlleniumAppearanceResourceName, Config.NotificationSystem)
        local permMessageApply, permMessageShow, permMessageConvertDb
        if Config.AdminAceIdentifier and Config.AdminAceIdentifier ~= "" then permMessageApply = string.format("Uso do /applypreset (NUI) restrito pela ACE: '%s'.", Config.AdminAceIdentifier)
        else permMessageApply = "AVISO: Nenhuma ACE definida para /applypreset (NUI). Comando aberto para todos." end
        if Config.AdminAceForTargetPreset and Config.AdminAceForTargetPreset ~= "" then
            permMessageShow = string.format("Uso do /preset [ServerID] restrito pela ACE: '%s'.", Config.AdminAceForTargetPreset)
            permMessageConvertDb = string.format("Uso do /convertpresetdb restrito pela ACE: '%s'.", Config.AdminAceForTargetPreset) 
        else
            permMessageShow = "AVISO: Nenhuma ACE definida para /preset [ServerID]. Comando aberto para todos."
            permMessageConvertDb = "AVISO: Nenhuma ACE definida para /convertpresetdb. Comando aberto para todos."
        end
        print(("^2IA_PRESET_CONVERTER: Servidor iniciado. Recurso Illenium: ^5%s^2. Notificações: ^5%s^2.\n^2%s\n^2%s\n^2%s^0"):format(
            Config.IlleniumAppearanceResourceName or "N/A", Config.NotificationSystem or "N/A",
            permMessageApply, permMessageShow, permMessageConvertDb)
        )
    end
end)

RegisterServerEvent('ia_preset_converter:server:requestApplyPreset')
AddEventHandler('ia_preset_converter:server:requestApplyPreset', function(presetType, presetJsonString, targetId)
    local sourceAdmin = source; local sourceAdminName = GetPlayerName(sourceAdmin); local actualTargetId = tonumber(targetId) or sourceAdmin
    if not (Config.AdminAceIdentifier and Config.AdminAceIdentifier ~= "" and IsPlayerAceAllowed(sourceAdmin, Config.AdminAceIdentifier)) then NotifyPlayer(sourceAdmin, "error", "Você não tem permissão para usar a funcionalidade de aplicar preset.", 7000); return end
    local isTargetOnline = GetPlayerName(actualTargetId) ~= nil; local targetPlayerNameForMsg = isTargetOnline and GetPlayerName(actualTargetId) or ("Jogador Offline (ID: " .. actualTargetId .. ")")
    if not isTargetOnline then NotifyPlayer(sourceAdmin, "error", "Não é possível aplicar preset. O jogador alvo (ID: " .. actualTargetId .. ") não está online.", 7000); return end
    local success, presetData = pcall(json.decode, presetJsonString)
    if not success or type(presetData) ~= "table" then NotifyPlayer(sourceAdmin, "error", string.format("Erro ao processar o JSON do preset para %s. Verifique o formato.", targetPlayerNameForMsg), 10000); return end
    if presetData.gener ~= nil and presetData.gender == nil then presetData.gender = presetData.gener; presetData.gener = nil end
    local looksLikeQB = presetData.faceFeatures and presetData.components and presetData.headBlend and type(presetData.faceFeatures) == "table"
    local looksLikeNation = (presetData['hair-color'] or presetData.eyesOpenning or presetData.blemishes ~= nil) and not (presetData.components and type(presetData.components) == "table" and #presetData.components > 0)
    if presetType == "qbcore" and not looksLikeQB and looksLikeNation then NotifyPlayer(sourceAdmin, "error", string.format("Para %s: Preset parece 'Nation', mas selecionou 'QB-Core'. Corrija.", targetPlayerNameForMsg), 10000); return
    elseif presetType == "nation" and not looksLikeNation and looksLikeQB then NotifyPlayer(sourceAdmin, "error", string.format("Para %s: Preset parece 'QB-Core', mas selecionou 'Nation'. Corrija.", targetPlayerNameForMsg), 10000); return
    elseif presetType == "qbcore" and not looksLikeQB then NotifyPlayer(sourceAdmin, "warning", string.format("Para %s: Preset não parece um formato QB-Core válido. Tentando mesmo assim...", targetPlayerNameForMsg), 10000)
    elseif presetType == "nation" and not looksLikeNation then NotifyPlayer(sourceAdmin, "warning", string.format("Para %s: Preset não parece um formato Nation válido. Tentando mesmo assim...", targetPlayerNameForMsg), 7000) end
    
    local currentTargetModel = nil; local targetCitizenId = nil
    if isTargetOnline and GetResourceState("qb-core") == "started" and exports['qb-core'] then
        local QBCore = exports['qb-core']:GetCoreObject(); local targetPlayer = QBCore.Functions.GetPlayer(actualTargetId)
        if targetPlayer and targetPlayer.PlayerData and targetPlayer.PlayerData.citizenid then targetCitizenId = targetPlayer.PlayerData.citizenid
        else NotifyPlayer(sourceAdmin, "warning", "Não foi possível obter o CitizenID do jogador alvo online (QBCore). O modelo base pode não ser o mais atual.", 6000) end
    end

    CreateThread(function()
        if targetCitizenId then
            exports.oxmysql.single_async('SELECT model FROM playerskins WHERE citizenid = ? AND active = 1 ORDER BY id DESC LIMIT 1', {targetCitizenId})
            :next(function(skinData)
                if skinData and skinData.model then currentTargetModel = skinData.model end
                
                local convertedData; if presetType == "qbcore" then convertedData = ConvertQBToIllenium(presetData, currentTargetModel) elseif presetType == "nation" then convertedData = ConvertNationToIllenium(presetData, currentTargetModel)
                else NotifyPlayer(sourceAdmin, "error", "Erro interno: Tipo de preset desconhecido.", 7000); return end

                if convertedData then
                    if not convertedData.model or convertedData.model == "" then NotifyPlayer(sourceAdmin, "warning", string.format("Modelo não pôde ser determinado para %s. Usando padrão %s.", targetPlayerNameForMsg, Config.DefaultMaleModel), 7000); convertedData.model = Config.DefaultMaleModel end
                    TriggerClientEvent('ia_preset_converter:client:receiveAndApplyPreset', actualTargetId, Config.IlleniumAppearanceResourceName, convertedData, sourceAdmin)
                    NotifyPlayer(sourceAdmin, "success", string.format("Preset parcialmente convertido! Aplicando em %s...", targetPlayerNameForMsg), 5000)
                    if actualTargetId ~= sourceAdmin and isTargetOnline then NotifyPlayer(actualTargetId, "inform", string.format("Um administrador (%s) aplicou um preset de aparência em você.", sourceAdminName), 7000) end
                else NotifyPlayer(sourceAdmin, "error", string.format("Falha ao converter o preset para %s. O formato pode estar incorreto ou dados insuficientes.", targetPlayerNameForMsg), 10000) end
            end, function(err)
                NotifyPlayer(sourceAdmin, "error", "Erro ao buscar modelo atual para " .. targetPlayerNameForMsg .. " do DB: " .. tostring(err), 8000)
                local convertedData; if presetType == "qbcore" then convertedData = ConvertQBToIllenium(presetData, nil) elseif presetType == "nation" then convertedData = ConvertNationToIllenium(presetData, nil) else return end
                if convertedData then if not convertedData.model or convertedData.model == "" then convertedData.model = Config.DefaultMaleModel end
                    TriggerClientEvent('ia_preset_converter:client:receiveAndApplyPreset', actualTargetId, Config.IlleniumAppearanceResourceName, convertedData, sourceAdmin)
                    NotifyPlayer(sourceAdmin, "success", string.format("Preset parcialmente convertido (sem modelo base do DB)! Aplicando em %s...", targetPlayerNameForMsg), 5000)
                    if actualTargetId ~= sourceAdmin and isTargetOnline then NotifyPlayer(actualTargetId, "inform", string.format("Um administrador (%s) aplicou um preset de aparência em você.", sourceAdminName), 7000) end
                end
            end)
        else 
            local convertedData; if presetType == "qbcore" then convertedData = ConvertQBToIllenium(presetData, nil) elseif presetType == "nation" then convertedData = ConvertNationToIllenium(presetData, nil) else NotifyPlayer(sourceAdmin, "error", "Erro interno: Tipo de preset desconhecido.", 7000); return end
            if convertedData then
                if not convertedData.model or convertedData.model == "" then NotifyPlayer(sourceAdmin, "warning", string.format("Modelo não pôde ser determinado para %s (sem CitizenID). Usando padrão %s.", targetPlayerNameForMsg, Config.DefaultMaleModel), 7000); convertedData.model = Config.DefaultMaleModel end
                TriggerClientEvent('ia_preset_converter:client:receiveAndApplyPreset', actualTargetId, Config.IlleniumAppearanceResourceName, convertedData, sourceAdmin)
                NotifyPlayer(sourceAdmin, "success", string.format("Preset parcialmente convertido! Aplicando em %s...", targetPlayerNameForMsg), 5000)
                if actualTargetId ~= sourceAdmin and isTargetOnline then NotifyPlayer(actualTargetId, "inform", string.format("Um administrador (%s) aplicou um preset de aparência em você.", sourceAdminName), 7000) end
            else NotifyPlayer(sourceAdmin, "error", string.format("Falha ao converter o preset para %s. O formato pode estar incorreto ou dados insuficientes.", targetPlayerNameForMsg), 10000) end
        end
    end)
end)

RegisterServerEvent('ia_preset_converter:server:requestShowPresetOnline')
AddEventHandler('ia_preset_converter:server:requestShowPresetOnline', function(targetServerId)
    local sourceAdmin = source
    if not (Config.AdminAceForTargetPreset and Config.AdminAceForTargetPreset ~= "" and IsPlayerAceAllowed(sourceAdmin, Config.AdminAceForTargetPreset)) then NotifyPlayer(sourceAdmin, "error", "Você não tem permissão para ver o preset de outros jogadores.", 7000); return end
    local targetIdNum = tonumber(targetServerId)
    if not targetIdNum or GetPlayerName(targetIdNum) == nil then NotifyPlayer(sourceAdmin, "error", "Jogador com Server ID " .. (targetServerId or "Inválido") .. " não está online ou o ID é inválido.", 7000); return end
    NotifyPlayer(sourceAdmin, "inform", "Solicitando preset do jogador online (ID: " .. targetIdNum .. ")...", 3000)
    TriggerClientEvent('ia_preset_converter:client:generateAndSendPresetToAdmin', targetIdNum, sourceAdmin)
end)

RegisterServerEvent('ia_preset_converter:server:forwardGeneratedPresetToAdmin')
AddEventHandler('ia_preset_converter:server:forwardGeneratedPresetToAdmin', function(adminSourceId, qbPresetJson, nationPresetJson, targetPlayerName)
    TriggerClientEvent('ia_preset_converter:client:displayAdminRequestedPreset', adminSourceId, qbPresetJson, nationPresetJson, targetPlayerName)
end)

RegisterServerEvent('ia_preset_converter:server:nuiClosedByClient')
AddEventHandler('ia_preset_converter:server:nuiClosedByClient', function()
end)


if not _G.GetPlayerIdentifiers then
    _G.GetPlayerIdentifiers = function(playerId)
        local identifiers = {}; if GetPlayerName(playerId) then
            local numIdentifiers = GetNumPlayerIdentifiers(playerId); for i = 0, numIdentifiers - 1 do table.insert(identifiers, GetPlayerIdentifier(playerId, i)) end
        end; return identifiers
    end
end
if not _G.GetPlayerIdentifier then
    _G.GetPlayerIdentifier = function(playerId, typeOrIndex)
        if GetPlayerName(playerId) then
            if type(typeOrIndex) == "number" then return GetPlayerIdentifier(playerId, typeOrIndex)
            elseif type(typeOrIndex) == "string" then
                 local numIdentifiers = GetNumPlayerIdentifiers(playerId); for i = 0, numIdentifiers - 1 do local id = GetPlayerIdentifier(playerId, i)
                    if id and string.sub(id, 1, #typeOrIndex + 1) == typeOrIndex .. ":" then return id end
                end
            end; return GetPlayerIdentifier(playerId, 0)
        end; return nil
    end
end