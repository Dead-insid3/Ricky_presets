Config = {}

Config.IlleniumAppearanceResourceName = "illenium-appearance"
Config.NotificationSystem = "qbcore" -- ou "oxlib", "chat", "none"

Config.AdminAceIdentifier = "ia_preset_converter.use"
Config.AdminAceForTargetPreset = "ia_preset_converter.showtarget"

Config.DefaultMaleModel = "mp_m_freemode_01"
Config.DefaultFemaleModel = "mp_f_freemode_01"

Config.IlleniumStructureBase = {
    headOverlays = {
        blush = {opacity = 0.0, secondColor = 0, color = 0, style = -1}, chestHair = {opacity = 0.0, secondColor = 0, color = 0, style = -1},
        beard = {opacity = 0.0, secondColor = 0, color = 0, style = -1}, moleAndFreckles = {opacity = 0.0, secondColor = 0, color = 0, style = -1},
        makeUp = {opacity = 0.0, secondColor = 0, color = 0, style = -1}, bodyBlemishes = {opacity = 0.0, secondColor = 0, color = 0, style = -1},
        eyebrows = {opacity = 1.0, secondColor = 0, color = 0, style = -1}, sunDamage = {opacity = 0.0, secondColor = 0, color = 0, style = -1},
        complexion = {opacity = 1.0, secondColor = 0, color = 0, style = -1}, blemishes = {opacity = 0.0, secondColor = 0, color = 0, style = -1},
        lipstick = {opacity = 0.0, secondColor = 0, color = 0, style = -1}, ageing = {opacity = 0.0, secondColor = 0, color = 0, style = -1}
    },
    props = {
        {prop_id = 0, drawable = -1, texture = -1}, {prop_id = 1, drawable = -1, texture = -1}, {prop_id = 2, drawable = -1, texture = -1},
        {prop_id = 6, drawable = -1, texture = -1}, {prop_id = 7, drawable = -1, texture = -1}
    },
    tattoos = {},
    hair = {texture = 0, highlight = 0, color = 0, style = 0},
    faceFeatures = {
        nosePeakHigh = 0.0, jawBoneBackSize = 0.0, nosePeakLowering = 0.0, cheeksBoneHigh = 0.0, nosePeakSize = 0.0, noseBoneTwist = 0.0,
        chinBoneSize = 0.0, chinBoneLowering = 0.0, noseBoneHigh = 0.0, chinHole = 0.0, noseWidth = 0.0, chinBoneLenght = 0.0,
        eyeBrownHigh = 0.0, lipsThickness = 0.0, cheeksBoneWidth = 0.0, eyeBrownForward = 0.0, neckThickness = 0.0, cheeksWidth = 0.0,
        jawBoneWidth = 0.0, eyesOpening = 0.0
    },
    model = "mp_m_freemode_01",
    headBlend = {skinThird = 0, shapeThird = 0, skinFirst = 0, shapeMix = 0.0, skinSecond = 0, shapeSecond = 0, thirdMix = 0.0, shapeFirst = 0, skinMix = 0.0},
    eyeColor = 0,
    components = {
        {component_id = 0, drawable = 0, texture = 0}, {component_id = 1, drawable = 0, texture = 0}, {component_id = 2, drawable = 0, texture = 0},
        {component_id = 3, drawable = 0, texture = 0}, {component_id = 4, drawable = 0, texture = 0}, {component_id = 5, drawable = 0, texture = 0},
        {component_id = 6, drawable = 0, texture = 0}, {component_id = 7, drawable = 0, texture = 0}, {component_id = 8, drawable = 0, texture = 0},
        {component_id = 9, drawable = 0, texture = 0}, {component_id = 10, drawable = 0, texture = 0}, {component_id = 11, drawable = 0, texture = 0}
    }
}

Config.FaceFeatureMapNationToIllenium = {
    ["chinHole"] = "chinHole",
    ["eyesOpenning"] = "eyesOpening", ["eyesOpening"] = "eyesOpening",
    ["nosePeakHeight"] = "nosePeakHigh", ["nose PeakHeight"] = "nosePeakHigh",
    ["noseBoneHigh"] = "noseBoneHigh", ["nose BoneHigh"] = "noseBoneHigh",
    ["nosePeakLength"] = "nosePeakSize", ["nose PeakLength"] = "nosePeakSize",
    ["cheeksBoneHigh"] = "cheeksBoneHigh", ["cheeks BoneHigh"] = "cheeksBoneHigh",
    ["noseWidth"] = "noseWidth",
    ["chinBoneLowering"] = "chinBoneLowering", ["chinBone Lowering"] = "chinBoneLowering",
    ["noseBoneTwist"] = "noseBoneTwist", ["nose BoneTwist"] = "noseBoneTwist",
    ["cheeksWidth"] = "cheeksWidth", ["cheeks Width"] = "cheeksWidth",
    ["neckThickness"] = "neckThickness", ["neck Thickness"] = "neckThickness",
    ["jawBoneBackLength"] = "jawBoneBackSize", ["jawBone BackLength"] = "jawBoneBackSize",
    ["jawBoneWidth"] = "jawBoneWidth",
    ["lipsThickness"] = "lipsThickness", ["lips Thickness"] = "lipsThickness",
    ["chinBoneLength"] = "chinBoneLenght", ["chinBone Length"] = "chinBoneLenght",
    ["eyeBrownForward"] = "eyeBrownForward", ["eyeBrown Forward"] = "eyeBrownForward",
    ["eyeBrownHigh"] = "eyeBrownHigh", ["eyeBrown High"] = "eyeBrownHigh",
    ["cheeksBoneWidth"] = "cheeksBoneWidth", ["cheeks BoneWidth"] = "cheeksBoneWidth",
    ["chinBoneWidth"] = "chinBoneSize"
}

Config.FaceFeatureMapIlleniumToNation = {
    nosePeakHigh = "nose PeakHeight",
    jawBoneBackSize = "jawBone BackLength",
    nosePeakLowering = "nose PeakLowering",
    cheeksBoneHigh = "cheeks BoneHigh",
    nosePeakSize = "nose PeakLength",
    noseBoneTwist = "nose BoneTwist",
    chinBoneSize = "chinBoneWidth",
    chinBoneLowering = "chinBone Lowering",
    noseBoneHigh = "nose BoneHigh",
    chinHole = "chinHole",
    noseWidth = "noseWidth",
    chinBoneLenght = "chinBone Length",
    eyeBrownHigh = "eyeBrown High",
    lipsThickness = "lips Thickness",
    cheeksBoneWidth = "cheeks BoneWidth",
    eyeBrownForward = "eyeBrown Forward",
    neckThickness = "neck Thickness",
    cheeksWidth = "cheeks Width",
    jawBoneWidth = "jawBoneWidth",
    eyesOpening = "eyesOpenning"
}

Config.HeadOverlayMapIlleniumToNation = {
    blemishes = { styleKey = "blemishes", opacityKey = "blemishes-opacity", colorKey = "blemishes-color"},
    makeup = { styleKey = "makeup", opacityKey = "makeup-opacity", colorKey = "makeup-color"},
    ageing = { styleKey = "ageing", opacityKey = "ageing-opacity", colorKey = "ageing-color"},
    eyebrows = { styleKey = "eyebrows", opacityKey = "eyebrows-opacity", colorKey = "eyebrows-color"},
    lipstick = { styleKey = "lipstick", opacityKey = "lipstick-opacity", colorKey = "lipstick-color"},
    sunDamage = { styleKey = "sunDamage", opacityKey = "sunDamage-opacity", colorKey = "sunDamage-color"},
    blush = { styleKey = "blush", opacityKey = "blush-opacity", colorKey = "blush-color"},
    complexion = { styleKey = "complexion", opacityKey = "complexion-opacity", colorKey = "complexion-color"},
    moleAndFreckles = { styleKey = "freckles", opacityKey = "freckles-opacity", colorKey = "freckles-color"},
    beard = { styleKey = "facialHair", opacityKey = "facialHair-opacity", colorKey = "facialHair-color"},
    chestHair = { styleKey = "chestHair", opacityKey = "chestHair-opacity", colorKey = "chestHair-color"},
    bodyBlemishes = { styleKey = "bodyBlemishes", opacityKey = "bodyBlemishes-opacity", colorKey = "bodyBlemishes-color"}
}