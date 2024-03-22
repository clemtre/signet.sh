//document.addEventListener("keydown", function(event) {
//    var keyPressed = event.key.toLowerCase();
//
//    if (keyPressed === 'p') {
//        const val = Math.round(Math.random()*255)
//        document.querySelector('body').style.background = `rgba(${val},${val /2},${val})`
//        console.log("The 'P' key was pressed");
//    }
//});

// Barre de recherche 
$(document).ready(function () {
    $('li').addClass('active')
    $('textarea').on('input', function () {
        var userInput = $(this).val().toLowerCase();

        $('li').each(function () {
            var listItemText = $(this).text().toLowerCase();
            if (listItemText.includes(userInput)) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });

    });
});

// On convertit les dates au format AA-MM-JJ
function formatDateFromEpoch(epochTime) {
    const date = new Date(epochTime * 1000); 

    const YY = date.getFullYear().toString()
    const MM = ('0' + (date.getMonth() + 1)).slice(-2)
    const DD = ('0' + date.getDate()).slice(-2)

    if(epochTime == ''){

        return `N/A`;
    }

    return `${YY}/${MM}/${DD}`;
}

const dates = document.querySelectorAll('h4')
dates.forEach((date) => {
    date.innerHTML= formatDateFromEpoch(date.innerHTML)
})

// On cache les descriptions si elles sont vides
$('h2').each(function() {
    $(this).html() == '' ? $(this).hide() : $(this).show() 
})

// On colore les entrées qui ont un attribut 'color'
$('[color]').each(function() {
    $(this).css('background', `linear-gradient(var(--background), ${$(this).attr('color')} `)

})
