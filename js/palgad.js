toHide = ['', 'Tüüp', 'Asutus']


var chart = c3.generate({
    data: {
        x : 'Inimesi',
        axes: {
            Mediaan: 'y'
        },
        hide: toHide,
        url: 'data/asutuse_kaupa.csv',
        type: 'scatter'
    },
    legend: {
        hide: toHide
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