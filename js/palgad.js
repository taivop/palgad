toHide = ['', 'Tüüp', 'Asutus']


var chart = c3.generate({
    data: {
        x : 'Inimesi',
        ys : {
            Mediaan: 'Mediaan',
            Keskmine: 'Keskmine'
        },
        hide: toHide,
        legend: {
            hide: toHide
        },
        url: 'data/asutuse_kaupa.csv',
        type: 'scatter'
    },
    axis: {
        x: {
            label: 'Inimesi',
            tick: {
                fit: false
            }
        },
        y: {
            label: 'Palk'
        }
    }
});