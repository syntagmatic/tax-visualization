var buffers;
buffers = {
  splatter: 'n = 16\n\ncreateAxis("100%","100%",40)\n\ncube = (x) -> pow(x,3)\npos  =-> 500 + cube (15 * (random()-0.5))\nsize =-> cube 4.5*random()\n\ncircles = set()\nfor i in [1..n]\n  circles.push circle(pos(),pos(),size())\n  .attr\n    fill: color = getColor()\n    opacity: 0.6\n    "stroke": "#333"\n    "stroke-width": 1\n    "stroke-opacity": 0\n\ncircles.mouseover ->\n  this.attr\n    "stroke-opacity": 1\n    opacity:0.85\n    cursor: "pointer"\ncircles.mouseout ->\n  this.anim\n    "stroke-opacity": 0\n    opacity:0.6\n    cursor: "pointer"\n    duration: 140',
  spiral: 'n = 100\n\ncreateAxis("100%","100%",40)\n\nposx = (x) -> 800 + 9*i*sin(pi/12*i)\nposy = (x) -> 500 + 9*i*cos(pi/12*i)\nsize = (x) -> x/2 + 1\n\ncircles = set()\nfor i in [1..n]\n  circles.push circle(posx(i),posy(i),size(i))\n  .attr\n    fill: color = getColor()\n    opacity: 0.6\n    "stroke": "#333"\n    "stroke-width": 1\n    "stroke-opacity": 0',
  chart: 'values = []\ndotsy = []\nclr = []\nc = path("M0,0").attr\n  fill: "none"\n  "stroke-width": 3\n\nfor i in [0..12]\n  values[i] = randomPath(30, i, dotsy)\n  clr[i] = Raphael.getColor()\n  c.attr({path: values[i], stroke: clr[i]})',
  equation: 'eq = (x) -> sin(x)  # equation\nmin = 0             # minimum\nmax = 4*pi          # maximum\ninc = pi/24         # increment size\nwidth = 600         # window width\nzoom = 120          # amplitude multiplier\nox = 400            # x of origin\noy = 400            # y of origin\n\nnum = (max-min) / inc\npoints = []\npoint = (x,y) -> circle(x,y,1)\nfor i in [0..num]\n  x = (inc*i + min)\n  y = eq x\n  points.push point(x*(width/num/inc) + ox, y*zoom + oy)',
  dvc: 'createAxis("100%","100%",40)'
};
$(document).ready(function() {
  var buffer, flipper;
  flipper = function(button, panel, showmsg, hidemsg) {
    return $(button).toggle(function() {
      $(this).html(hidemsg);
      return $(panel).fadeIn();
    }, function() {
      $(this).html(showmsg);
      return $(panel).fadeOut();
    });
  };
  flipper("#show", "#code", "Code", "Hide Code");
  flipper("#cons", "#console", "Console", "Hide Console");
  flipper("#tut", "#tutorial", "Tutorial", "Hide Tutorial");
  flipper("#out", "#output_window", "Output", "Hide Output");
  $("#buffers").change(function() {
    var buffer;
    buffer = $(this).val();
    return $("#code").html(buffers[buffer]);
  });
  buffer = $("#buffers").val();
  $("#code").html(buffers[buffer]);
  dvc();
  return window.expose = function(item) {
    var i, str;
    str = "";
    for (i = 0; i <= 13; i++) {
      str += "<b>" + (nab('name', item, i)) + "</b>: " + (nab('value', item, i)) + "<br/>";
    }
    return $('#output_window').html(str);
  };
});