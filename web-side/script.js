let selectedPassport = null;

// Evento que escuta mensagens vindas do servidor
window.addEventListener('message', function (event) {
    const data = event.data;

    if (data.Action === 'Spawn') {
        $("#ui-container").css("display", "block");
        const $characterList = $('#character-list');
        $characterList.empty();

        // Adiciona cada personagem à lista
        data.Table.forEach(character => {
            const $characterContainer = $('<div></div>', {
                'class': 'character-item',
                'data-passport': character.Passport
            });

            selectedPassport = character.Passport;

            const $nameSpan = $('<span></span>', {
                'class': 'character-name'
            }).text(`${character.Nome}`);

            const $idSpan = $('<span></span>', {
                'class': 'character-id'
            }).text(`ID: ${character.Passport}`);

            const $progressBar = $('<div></div>', {
                'class': 'progress-bar'
            });


            $characterContainer.append($progressBar, $nameSpan, $idSpan);
            $characterList.append($characterContainer);

            let interval;
            let progress = 0;

            $characterList.on('mousedown', function () {
                progress = 0;
                $progressBar.css('width', '0%');

                interval = setInterval(() => {
                    progress += 2;
                    $progressBar.css('width', `${progress}%`);

                    if (progress >= 100) {
                        clearInterval(interval);
                        enviarEscolha(character.Passport);
                    }
                }, 50);
            });

            $characterList.on('mouseup mouseleave', function () {
                clearInterval(interval);
                $progressBar.css('width', '0%');
            });
        });

        function enviarEscolha(passport) {
            fetch(`http://spawn/CharacterChosen`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify({ Passport: passport })
            }).catch(error => {
                console.error('Problema na operação:', error);
            });
        }
    }

    // Verifica se a ação é "Close"
    if (data.Action === "Close") {
        $("#ui-container").css("display", "none");
    }
});


$("#new-character").on("click", function () {
    $(".comprar-personagem").fadeIn();
    $(".background").fadeIn();


    $(".cancelar").on("click", function () {
        $(".comprar-personagem").fadeOut();
        $(".background").fadeOut();
    });
});

$(document).ready(() => {

    $("#new-character").on("click", function () {
        $(".comprar-personagem").fadeIn();
        $(".background").fadeIn();
    });

    $("#cancelar").on("click", function () {
        $(".comprar-personagem").fadeOut();
        $(".background").fadeOut();
    });
})
