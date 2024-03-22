const textarea = document.querySelector('textarea')

function updateValue(e) {
    let val = textarea.value.toLowerCase()
    document.querySelectorAll('.signets tr').forEach((e) => {
        var listItemText = e.innerHTML.toLowerCase();
        listItemText.includes(val) ? 
            e.classList.remove('hidden') : e.classList.add('hidden')        
    })
}

document.addEventListener("DOMContentLoaded", function(event) {
    textarea.addEventListener("input", updateValue);
})

document.querySelectorAll('[color]').forEach((e) => {
    e.style.background = `linear-gradient(var(--background), ${e.getAttribute('color')} `

})
