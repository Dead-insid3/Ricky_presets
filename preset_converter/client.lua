local currentOpenNuiType = nil -- nil, "apply", "show", "convertDb"
local illeniumResourceName = nil
local notificationSystemType = "chat" -- Padrão se não configurado pelo servidor

local function ShowNotification(messageType, message, duration)
    duration = duration or 5000
    local currentNotifySystemToUse = notificationSystemType or "chat"
    if currentNotifySystemToUse == "qbcore" then
        if exports['qb-core'] and exports['qb-core'].GetCoreObject then
            local QBCore = exports['qb-core']:GetCoreObject()
            if QBCore and QBCore.Functions and QBCore.Functions.Notify then
                local qbMessageType = messageType
                if messageType == "inform" then qbMessageType = "primary" 
                elseif messageType == "warning" then qbMessageType = "warning" 
                end
                QBCore.Functions.Notify(message, qbMessageType, duration)
            else TriggerEvent('chat:addMessage', { color = {255,165,0}, args = {"[PresetConverter Aviso]", message} }) end
        else TriggerEvent('chat:addMessage', { color = {255,165,0}, args = {"[PresetConverter Aviso]", message} }) end
    elseif currentNotifySystemToUse == "oxlib" then
        if lib and lib.notify then 
            lib.notify({title = "Preset Converter", description = message, type = messageType, duration = duration})
        else TriggerEvent('chat:addMessage', { color = {255,165,0}, args = {"[PresetConverter Aviso]", message} }) end
    elseif currentNotifySystemToUse == "chat" then
        local color = {100, 180, 255} 
        if messageType == "error" then color = {255, 80, 80} 
        elseif messageType == "success" then color = {80, 255, 80} 
        elseif messageType == "warning" then color = {255, 180, 80} 
        end
        TriggerEvent('chat:addMessage', { color = color, multiline = true, args = {"^3[PresetConverter]^0", message} })
    elseif currentNotifySystemToUse == "none" then
        -- Não faz nada
    else 
        TriggerEvent('chat:addMessage', { color = {255,165,0}, args = {"[PresetConverter Fallback]", message} }) 
    end
end

RegisterNetEvent('ia_preset_converter:client:ShowNotification', ShowNotification)

local function OpenNuiInterface(nuiType)
    if currentOpenNuiType then 
        ShowNotification("inform", "Por favor, feche a interface atual antes de abrir uma nova.", 3000)
        return
    end
    currentOpenNuiType = nuiType
    SetNuiFocus(true, true)
    if nuiType == "apply" then
        SendNUIMessage({type = 'showPresetUI'})
    elseif nuiType == "convertDb" then
        SendNUIMessage({type = 'showConvertFromDbNUI'})
    elseif nuiType == "show" then
    end
end

RegisterCommand('applypreset', function(source, args, rawCommand)
    OpenNuiInterface('apply')
end, false)

RegisterCommand('preset', function(source, args, rawCommand)
    local targetServerId = tonumber(args[1])
    if not targetServerId then
        ShowNotification("error", "Uso: /preset [ServerID_do_Jogador_Online]", 7000)
        return
    end
    TriggerServerEvent('ia_preset_converter:server:requestShowPresetOnline', targetServerId)
end, false)

RegisterCommand('convertpresetdb', function(source, args, rawCommand)
    local hasPermission = false
    if Config.AdminAceForTargetPreset and Config.AdminAceForTargetPreset ~= "" then
        hasPermission = true
    else 
        hasPermission = true
    end

    if not hasPermission and Config.AdminAceForTargetPreset and Config.AdminAceForTargetPreset ~= "" then
        ShowNotification("error", "Você não tem permissão para usar este comando.", 7000)
        return
    end
    OpenNuiInterface('convertDb')
end, false)


RegisterNUICallback('applyPreset', function(data, cb)
    local presetType = data.type; local jsonString = data.json_data; local targetId = data.target_id
    if not jsonString or jsonString:gsub("%s+", "") == "" then cb({status = 'error', message = 'O campo JSON do Preset não pode estar vazio.'}); ShowNotification("error", 'O campo JSON do Preset não pode estar vazio.', 7000); return end
    local successDecode, _ = pcall(json.decode, jsonString)
    if not successDecode then cb({status = 'error', message = 'O formato do JSON do preset é inválido!'}); ShowNotification("error", 'O formato do JSON do preset é inválido!', 7000); return end
    local targetIdToSend = targetId; if targetId == nil or targetId == "" then targetIdToSend = nil else targetIdToSend = tonumber(targetId) end
    TriggerServerEvent('ia_preset_converter:server:requestApplyPreset', presetType, jsonString, targetIdToSend)
    cb({status = 'ok'}) 
end)

RegisterNUICallback('convertManualPreset', function(data, cb)
    local illeniumJsonString = data.illeniumJsonString
    if not illeniumJsonString or illeniumJsonString:gsub("%s+", "") == "" then
        cb({status = 'error', message = 'O JSON da Skin (DB) não pode estar vazio.'}); ShowNotification("error", "O JSON da Skin (DB) não pode estar vazio.", 7000); return
    end
    local successDecode, illeniumData = pcall(json.decode, illeniumJsonString)
    if not successDecode or type(illeniumData) ~= "table" then
        cb({status = 'error', message = 'O JSON da Skin (DB) fornecido é inválido.'}); ShowNotification("error", "O JSON da Skin (DB) fornecido é inválido.", 7000); return
    end
    if not illeniumData.model then
        cb({status = 'error', message = 'O JSON fornecido não parece ser um preset Illenium válido (falta o campo "model").'}); ShowNotification("error", 'O JSON fornecido não parece ser um preset Illenium válido (falta o campo "model").', 7000); return
    end

    local qbPreset = ConvertIlleniumToQB(illeniumData)
    local nationPreset = ConvertIlleniumToNation(illeniumData)

    if qbPreset and nationPreset then
        SendNUIMessage({
            type = 'showCurrentPresetNUI',
            qbPresetJson = json.encode(qbPreset),
            nationPresetJson = json.encode(nationPreset),
            playerName = "Preset Convertido (DB Manual)"
        })
        cb({status = 'ok'}) 
        currentOpenNuiType = "show"
        SetNuiFocus(true, true)
    else
        cb({status = 'error', message = 'Falha ao converter o JSON da Skin (DB). Verifique o console (F8).'}); ShowNotification("error", "Falha ao converter o JSON da Skin (DB). Verifique o console (F8).", 7000)
    end
end)

RegisterNUICallback('nuiClosed', function(data, cb)
    if currentOpenNuiType ~= nil then
        SetNuiFocus(false, false)
        currentOpenNuiType = nil
    end
    cb({status = 'ok'})
end)

RegisterNetEvent('ia_preset_converter:client:receiveAndApplyPreset')
AddEventHandler('ia_preset_converter:client:receiveAndApplyPreset', function(resourceNameToUse, serverConvertedData, sourceAdminId)
    local currentIlleniumResName = resourceNameToUse or illeniumResourceName
    if not currentIlleniumResName then ShowNotification("error", "Falha crítica (Cod:ILLRES_UNDEF_CLI): Não foi possível aplicar.", 10000); if sourceAdminId then TriggerClientEvent('ia_preset_converter:client:ShowNotification', sourceAdminId, "error", "Falha crítica (Cod:ILLRES_UNDEF_CLI) no cliente alvo.", 10000) end; return end
    if not serverConvertedData or type(serverConvertedData) ~= "table" then ShowNotification("error", "Recebeu dados de aparência inválidos do servidor (Cod:CONVDATA_CLI).", 7000); if sourceAdminId then TriggerClientEvent('ia_preset_converter:client:ShowNotification', sourceAdminId, "error", "Cliente alvo recebeu dados de aparência inválidos (Cod:CONVDATA_CLI).", 7000) end; return end
    local playerPed = PlayerPedId(); local currentAppearance = exports[currentIlleniumResName]:getPedAppearance(playerPed)
    if not currentAppearance then ShowNotification("warning", "Não foi possível obter aparência atual para mesclagem (Cod:GETAPP_CLI).", 7000); currentAppearance = DeepCopyTable(Config.IlleniumStructureBase)
        if serverConvertedData.model and serverConvertedData.model ~= "" then currentAppearance.model = serverConvertedData.model elseif not currentAppearance.model or currentAppearance.model == "" then currentAppearance.model = Config.DefaultMaleModel end
    end
    local finalAppearanceData = DeepMergeRecursive(currentAppearance, serverConvertedData)
    local function EnsureCompleteStructure(target, baseStructure) local completed = DeepCopyTable(target)
        for key, base_value in pairs(baseStructure) do
            if completed[key] == nil then completed[key] = DeepCopyTable(base_value)
            elseif type(base_value) == "table" and type(completed[key]) == "table" then completed[key] = EnsureCompleteStructure(completed[key], base_value)
            elseif type(base_value) == "table" and type(completed[key]) ~= "table" then completed[key] = DeepCopyTable(base_value) end
        end; return completed
    end
    finalAppearanceData = EnsureCompleteStructure(finalAppearanceData, Config.IlleniumStructureBase)
    if not finalAppearanceData.model or finalAppearanceData.model == "" then ShowNotification("error", "Falha crítica: Modelo inválido (Cod:FINALMODEL_NIL_CLI). Usando padrão.", 10000); finalAppearanceData.model = (currentAppearance and currentAppearance.model and currentAppearance.model ~= "") and currentAppearance.model or Config.DefaultMaleModel
        if sourceAdminId then TriggerClientEvent('ia_preset_converter:client:ShowNotification', sourceAdminId, "error", "Falha crítica (Cod:FINALMODEL_NIL_CLI) no cliente alvo. Modelo padrão aplicado.", 10000) end
    end
    if type(finalAppearanceData.model) == "number" then finalAppearanceData.model = tostring(finalAppearanceData.model) end
    if exports[currentIlleniumResName] and exports[currentIlleniumResName].setPlayerAppearance then
        exports[currentIlleniumResName]:setPlayerAppearance(finalAppearanceData)
        ShowNotification("success", "Sua aparência foi atualizada! Tentando salvar...", 7000)
        if sourceAdminId and GetPlayerServerId(PlayerId()) ~= sourceAdminId then TriggerClientEvent('ia_preset_converter:client:ShowNotification', sourceAdminId, "success", "Aparência aplicada com sucesso no jogador alvo!", 7000) end
        TriggerServerEvent(currentIlleniumResName .. ":server:saveAppearance", finalAppearanceData)
    else ShowNotification("error", "Falha crítica (Cod:NOEXPORT_CLI): Não foi possível aplicar.", 10000); if sourceAdminId then TriggerClientEvent('ia_preset_converter:client:ShowNotification', sourceAdminId, "error", "Falha crítica (Cod:NOEXPORT_CLI) no cliente alvo.", 10000) end
    end
end)

RegisterNetEvent('ia_preset_converter:client:setInitialConfig')
AddEventHandler('ia_preset_converter:client:setInitialConfig', function(resName, notifySystem)
    if resName and type(resName) == "string" and resName ~= "" then illeniumResourceName = resName else illeniumResourceName = nil end
    if notifySystem and type(notifySystem) == "string" and (notifySystem == "qbcore" or notifySystem == "oxlib" or notifySystem == "chat" or notifySystem == "none") then notificationSystemType = notifySystem else notificationSystemType = "chat" end
end)

RegisterNetEvent('ia_preset_converter:client:generateAndSendPresetToAdmin')
AddEventHandler('ia_preset_converter:client:generateAndSendPresetToAdmin', function(adminRequestingSourceId)
    if not illeniumResourceName then ShowNotification("error", "Recurso Illenium não configurado (Cod:ILLRES_GEN_CLI).", 5000); return end
    local appearanceLib = exports[illeniumResourceName]
    if not (appearanceLib and appearanceLib.getPedAppearance) then ShowNotification("error", "Export 'getPedAppearance' do '"..tostring(illeniumResourceName).."' não encontrada (Cod:NOEXPORT_GEN_CLI).", 7000); TriggerServerEvent('ia_preset_converter:server:forwardGeneratedPresetToAdmin', adminRequestingSourceId, "ERRO: getPedAppearance não encontrado no cliente alvo.", "ERRO: getPedAppearance não encontrado no cliente alvo.", GetPlayerName(PlayerId()) .. " (ID: " .. GetPlayerServerId(PlayerId()) .. ")"); return end
    local currentAppearance = appearanceLib:getPedAppearance(PlayerPedId())
    if not currentAppearance then ShowNotification("error", "Não foi possível obter a aparência atual (Cod:GETAPP_GEN_CLI).", 5000); TriggerServerEvent('ia_preset_converter:server:forwardGeneratedPresetToAdmin', adminRequestingSourceId, "ERRO: Não foi possível obter aparência no cliente alvo.", "ERRO: Não foi possível obter aparência no cliente alvo.", GetPlayerName(PlayerId()) .. " (ID: " .. GetPlayerServerId(PlayerId()) .. ")"); return end
    local qbPreset = ConvertIlleniumToQB(currentAppearance); local nationPreset = ConvertIlleniumToNation(currentAppearance)
    local targetPlayerName = GetPlayerName(PlayerId()) .. " (ID: " .. GetPlayerServerId(PlayerId()) .. ")"
    TriggerServerEvent('ia_preset_converter:server:forwardGeneratedPresetToAdmin', adminRequestingSourceId, json.encode(qbPreset), json.encode(nationPreset), targetPlayerName)
end)

RegisterNetEvent('ia_preset_converter:client:displayAdminRequestedPreset')
AddEventHandler('ia_preset_converter:client:displayAdminRequestedPreset', function(qbPresetJson, nationPresetJson, targetPlayerName)
    if currentOpenNuiType then
        SendNUIMessage({type = 'hideAllUI'})
    
    end
    currentOpenNuiType = "show"
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showCurrentPresetNUI', 
        qbPresetJson = qbPresetJson, 
        nationPresetJson = nationPresetJson, 
        playerName = "Preset de: " .. targetPlayerName
    })
end)
