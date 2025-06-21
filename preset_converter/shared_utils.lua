DeepCopyTable = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopyTable(orig_key)] = DeepCopyTable(orig_value)
        end
        setmetatable(copy, DeepCopyTable(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

DeepMergeRecursive = function(base, overlay)
    local result = DeepCopyTable(base)
    if type(overlay) ~= "table" then
        if overlay ~= nil then return overlay end
        return result
    end

    for key, overlay_value in pairs(overlay) do
        if overlay_value ~= nil then
            if type(overlay_value) == "table" and overlay_value ~= {} then
                if type(result[key]) == "table" then
                    result[key] = DeepMergeRecursive(result[key], overlay_value)
                else
                    result[key] = DeepCopyTable(overlay_value)
                end
            elseif type(overlay_value) == "table" and overlay_value == {} then
                 result[key] = {}
            else -- Primitive value or nil
                result[key] = overlay_value
            end
        end
    end
    return result
end

ConvertIlleniumToQB = function(illeniumData)
    if not illeniumData or type(illeniumData) ~= "table" then return nil end
    local qbData = {}
    if illeniumData.model then qbData.model = illeniumData.model end
    if illeniumData.headBlend then qbData.headBlend = DeepCopyTable(illeniumData.headBlend) end
    if illeniumData.faceFeatures then qbData.faceFeatures = DeepCopyTable(illeniumData.faceFeatures) end
    if illeniumData.hair then qbData.hair = DeepCopyTable(illeniumData.hair) end
    if illeniumData.eyeColor ~= nil then qbData.eyeColor = illeniumData.eyeColor end
    if illeniumData.headOverlays then qbData.headOverlays = DeepCopyTable(illeniumData.headOverlays) end
    if illeniumData.components then qbData.components = DeepCopyTable(illeniumData.components) end
    if illeniumData.props then qbData.props = DeepCopyTable(illeniumData.props) end

    qbData.tattoos = {}
    if illeniumData.tattoos and type(illeniumData.tattoos) == "table" then
        for zoneName, zoneTattoos in pairs(illeniumData.tattoos) do
            if type(zoneTattoos) == "table" then
                for _, tattooEntry in ipairs(zoneTattoos) do
                    table.insert(qbData.tattoos, {
                        collection = tattooEntry.collection,
                        overlay = tattooEntry.overlay,
                        nameHash = tattooEntry.overlay,
                        zone = zoneName,
                        opacity = tattooEntry.opacity,
                        hashMale = tattooEntry.hashMale or tattooEntry.overlay,
                        hashFemale = tattooEntry.hashFemale or tattooEntry.overlay
                    })
                end
            end
        end
    end
    return qbData
end

ConvertIlleniumToNation = function(illeniumData)
    if not illeniumData or type(illeniumData) ~= "table" then return nil end
    local nationData = {}

    if illeniumData.model then
        if illeniumData.model == GetHashKey("mp_m_freemode_01") or illeniumData.model == "mp_m_freemode_01" or illeniumData.model == Config.DefaultMaleModel then
            nationData.gender = "male"
        elseif illeniumData.model == GetHashKey("mp_f_freemode_01") or illeniumData.model == "mp_f_freemode_01" or illeniumData.model == Config.DefaultFemaleModel then
            nationData.gender = "female"
        else
            nationData.gender = "male"
        end
    end

    if illeniumData.headBlend then
        for k, v in pairs(illeniumData.headBlend) do nationData[k] = v end
    end
    if illeniumData.hair then
        nationData.hair = illeniumData.hair.style
        nationData['hair-color'] = illeniumData.hair.color
        nationData['hair-highlightcolor'] = illeniumData.hair.highlight
    end
    if illeniumData.faceFeatures then
        for illKey, nationKey in pairs(Config.FaceFeatureMapIlleniumToNation or {}) do
            if illeniumData.faceFeatures[illKey] ~= nil then nationData[nationKey] = illeniumData.faceFeatures[illKey] end
        end
    end
    if illeniumData.eyeColor ~= nil then nationData.eyes = illeniumData.eyeColor end

    if illeniumData.headOverlays then
        for illOverlayName, nationKeys in pairs(Config.HeadOverlayMapIlleniumToNation or {}) do
            if illeniumData.headOverlays[illOverlayName] then
                nationData[nationKeys.styleKey] = illeniumData.headOverlays[illOverlayName].style
                nationData[nationKeys.opacityKey] = illeniumData.headOverlays[illOverlayName].opacity
                nationData[nationKeys.colorKey] = illeniumData.headOverlays[illOverlayName].color
            end
        end
    end
    nationData.tattoos = {}
    if illeniumData.tattoos and type(illeniumData.tattoos) == "table" then
        for _, zoneTattoos in pairs(illeniumData.tattoos) do
            if type(zoneTattoos) == "table" then
                for _, tattooEntry in ipairs(zoneTattoos) do
                    table.insert(nationData.tattoos, {
                        collection = tattooEntry.collection,
                        overlay = tattooEntry.overlay
                    })
                end
            end
        end
    end
    return nationData
end