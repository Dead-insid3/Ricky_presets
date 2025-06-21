<br clear="both">

<h1 align="center">💅 QB - Core Presets (Player / Ped)</h1>

###

<p align="center">O script ia_preset_converter é uma ferramenta desenvolvida para facilitar a conversão e aplicação de presets de aparência de personagens entre diferentes frameworks de RP, especificamente QB-Core e Nation, para o sistema Illenium Appearance. Ele permite que administradores apliquem presets diretamente em jogadores online e também oferece funcionalidades para visualizar e converter dados de aparência.<br><br>Funcionalidades Principais:<br><br>Conversão de Presets:<br>Converte dados de preset do formato QB-Core para o formato Illenium Appearance.<br><br>Converte dados de preset do formato Nation para o formato Illenium Appearance.<br><br>Oferece funções utilitárias compartilhadas (shared_utils.lua) para realizar conversões inversas (Illenium para QB e Illenium para Nation) para visualização.<br><br>Aplicação de Presets:<br>Administradores podem usar um comando (/applypreset) para abrir uma interface NUI (via html/ui.html) onde podem colar um JSON de preset (QB-Core ou Nation) e aplicá-lo a um jogador online (ou a si mesmos).<br><br>O script tenta obter o modelo de skin atual do jogador alvo do banco de dados (se qb-core estiver rodando) para garantir uma conversão mais precisa.<br><br>Visualização de Presets:<br><br>Um comando (/preset [ServerID]) permite que administradores solicitem e visualizem os presets QB-Core e Nation gerados a partir da aparência atual de um jogador online.<br><br>Conversão de Presets de Banco de Dados (Manual):<br><br>O comando /convertpresetdb abre uma NUI que permite ao administrador colar um JSON de aparência diretamente do banco de dados (no formato Illenium, como seria salvo) e convertê-lo para os formatos QB-Core e Nation para visualização.<br><br>Sistema de Notificação Flexível:<br>Configurável para usar os sistemas de notificação do QB-Core, ox_lib, chat padrão do FiveM, ou desativar completamente as notificações.</p>

###

<br clear="both">

<h3 align="center">🤖 Dependências:</h3>

###

<p align="center">illenium-appearance: O recurso principal para o qual os presets são convertidos e aplicados. O nome do recurso é configurável.<br><br>@oxmysql/lib/MySQL.lua: Utilizado no lado do servidor para consultar o banco de dados e obter o modelo de skin atual do jogador, o que ajuda na conversão de presets.<br><br>qb-core (Opcional, para funcionalidades aprimoradas): Se presente e em execução, o script tenta usar as funções de notificação do QB-Core e obter o citizenid do jogador para consultar o modelo de skin no banco de dados.<br><br>ox_lib (Opcional, para notificações): Se configurado e presente, utiliza o sistema de notificação do ox_lib.</p>

###

<h5 align="center">💕 Nota:</h5>

###

<p align="left">Esse script nasceu pela Dificuldade em encontrar suporte ou ajuda para Tirar duvidas sobre Presets de Personagens na Linguagem .lua e Devs da Area. <br><br>Pretendo disponibilizar gratuitamente este e quaisquer scripts que eu possa ter Criado para Quaisquer funções que me pareçam Válidas.<br><br>Qualquer atualização será bem-vinda mas espero que não Revendam ou tentem obter Lucro com esse Script pois não é essa sua Finalidade.<br><br>Espero poder ajudar quaisquer pessoas que precisem desse script e possam encontrar nele alguma Estabilidade e Trabalho desnecessário.</p>

###
