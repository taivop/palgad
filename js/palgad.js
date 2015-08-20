nv.addGraph(function() {
    var chart = nv.models.scatterChart()
        .showDistX(true)    //showDist, when true, will display those little distribution lines on the axis.
        .showDistY(true)
        //.transitionDuration(350)
        .color(d3.scale.category10().range());

    //Configure how the tooltip looks.
    chart.tooltipContent(function(key) {
        return '<h3>' + key + '</h3>';
    });

    //Axis settings
    chart.xAxis.tickFormat(d3.format('.02f'));
    chart.yAxis.tickFormat(d3.format('.02f'));

    //We want to show shapes other than circles.
    chart.scatter.onlyCircles(false);

    rowParser = function(d) {
        return {
            Asutus: d.Asutus,
            Mediaan: +d.Mediaan
        }
    }

    console.log("asd")

    d3.csv("data/asutuse_kaupa.csv")
        .row(rowParser)
        .get(function(error, rows) {
            console.log(rows)
        });

    /*
        a = function(error, rows) {
        var myData = rows;

        console.log(rows)

        d3.select('#chart svg')
            .datum(myData)
            .call(chart);

        nv.utils.windowResize(chart.update);

        return chart;
    })*/
});