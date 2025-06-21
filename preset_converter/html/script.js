$(function() {
    const presetApplierContainer = $("#presetApplierContainer");
    const showPresetContainer = $("#showPresetContainer");
    const convertFromDbContainer = $("#convertFromDbContainer");
    const allContainers = [presetApplierContainer, showPresetContainer, convertFromDbContainer];

    const targetPlayerIdInput = $("#targetPlayerId");
    const presetTypeSelect = $("#presetType");
    const presetInputTextarea = $("#presetInput");
    const applyErrorMessageDiv = $("#errorMessage");

    const showPresetTitle = $("#showPresetTitle");
    const currentQbPresetTextarea = $("#currentQbPreset");
    const currentNationPresetTextarea = $("#currentNationPreset");

    const dbPresetInputTextarea = $("#dbPresetInput");
    const convertDbErrorMessageDiv = $("#convertDbErrorMessage");

    let currentVisibleNui = null;

    function displayError(message, errorDivElement) {
        errorDivElement.text(message).fadeIn();
        setTimeout(() => {
            errorDivElement.fadeOut().text("");
        }, 5000);
    }

    function hideAllNuisAndReleaseFocus() {
        allContainers.forEach(container => container.fadeOut(200));
        currentVisibleNui = null;
        $.post(`https://${GetParentResourceName()}/nuiClosed`, JSON.stringify({})); // Informa Lua para liberar foco
    }

    function openNui(nuiType) {
        allContainers.forEach(container => container.hide());

        currentVisibleNui = nuiType;

        if (nuiType === 'apply') {
            applyErrorMessageDiv.text("").hide();
            targetPlayerIdInput.val(''); 
            presetInputTextarea.val(''); 
            presetApplierContainer.fadeIn(200);
        } else if (nuiType === 'show') {
            showPresetContainer.fadeIn(200);
        } else if (nuiType === 'convertDb') {
            convertDbErrorMessageDiv.text("").hide();
            dbPresetInputTextarea.val('');
            convertFromDbContainer.fadeIn(200);
        }
    }

    window.addEventListener('message', function(event) {
        const data = event.data;
        if (data.type === 'showPresetUI') {
            openNui('apply');
        } else if (data.type === 'showCurrentPresetNUI') {
            currentQbPresetTextarea.val(data.qbPresetJson ? JSON.stringify(JSON.parse(data.qbPresetJson), null, 2) : "Erro ao gerar preset QB-Core.");
            currentNationPresetTextarea.val(data.nationPresetJson ? JSON.stringify(JSON.parse(data.nationPresetJson), null, 2) : "Erro ao gerar preset Nation.");
            showPresetTitle.text(data.playerName || "Presets Convertidos");
            openNui('show');
        } else if (data.type === 'showConvertFromDbNUI') {
            openNui('convertDb');
        } else if (data.type === 'hideAllUI') {
            hideAllNuisAndReleaseFocus();
        }
    });

    $("#applyBtn").click(function() {
        const presetType = presetTypeSelect.val();
        const presetJsonString = presetInputTextarea.val();
        const targetPlayerId = targetPlayerIdInput.val().trim(); 

        applyErrorMessageDiv.text("").hide();

        if (!presetJsonString.trim()) {
            displayError("O campo JSON do Preset não pode estar vazio.", applyErrorMessageDiv);
            return;
        }
        try { 
            JSON.parse(presetJsonString); 
        } catch (e) {
            displayError("O texto fornecido não é um JSON válido.", applyErrorMessageDiv); 
            return; 
        }
        
        let targetIdToSend = null;
        if (targetPlayerId !== "") {
            const parsedId = parseInt(targetPlayerId);
            if (!isNaN(parsedId) && parsedId >= 0) { 
                targetIdToSend = parsedId;
            } else { 
                displayError("ID do Jogador Alvo inválido.", applyErrorMessageDiv); 
                return; 
            }
        }

        $.post(`https://${GetParentResourceName()}/applyPreset`, JSON.stringify({ 
            type: presetType, 
            json_data: presetJsonString, 
            target_id: targetIdToSend 
        })).done(function(response) {
            if (response && response.status === 'error') { 
                displayError(response.message || "Erro no callback de applyPreset.", applyErrorMessageDiv);
            } else if (response && response.status === 'ok'){
                 hideAllNuisAndReleaseFocus(); 
            }
        }).fail(function() { 
            displayError("Falha ao comunicar com o servidor (applyPreset).", applyErrorMessageDiv); 
        });
    });

    $("#convertDbBtn").click(function() {
        const illeniumJsonString = dbPresetInputTextarea.val();
        convertDbErrorMessageDiv.text("").hide();

        if (!illeniumJsonString.trim()) {
            displayError("O campo JSON da Skin (DB) não pode estar vazio.", convertDbErrorMessageDiv);
            return;
        }
        try {
            JSON.parse(illeniumJsonString);
        } catch (e) {
            displayError("O texto fornecido não é um JSON válido.", convertDbErrorMessageDiv);
            return;
        }

        $.post(`https://${GetParentResourceName()}/convertManualPreset`, JSON.stringify({
            illeniumJsonString: illeniumJsonString
        })).done(function(response) {
            if (response && response.status === 'error') {
                displayError(response.message || "Erro ao processar no cliente (callback de convertManualPreset).", convertDbErrorMessageDiv);
            } else if (response && response.status === 'ok'){
                convertFromDbContainer.fadeOut(200);
            }
        }).fail(function() {
            displayError("Falha ao comunicar com o resource (convertManualPreset).", convertDbErrorMessageDiv);
        });
    });

    $("#closeBtn").click(function() {
        hideAllNuisAndReleaseFocus();
    });
    $("#closeShowPresetBtn").click(function() {
        hideAllNuisAndReleaseFocus();
    });
    $("#closeConvertDbBtn").click(function() {
        hideAllNuisAndReleaseFocus();
    });

    document.onkeyup = function (event) {
        if (event.key === 'Escape') {
            if (currentVisibleNui) {
                hideAllNuisAndReleaseFocus();
            }
        }
    };

    allContainers.forEach(container => container.hide());
});