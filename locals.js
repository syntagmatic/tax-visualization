var init2, randomPath;
init2 = function() {
  var attr, attrs, attrs2, c, cheight, cwidth, height, paper, width, _i, _len, _results;
  paper = Raphael("canvas", $('#canvas').width(), $('#canvas').height());
  window.paper = paper;
  width = "100%";
  height = "100%";
  c = paper.rect(0, 0, "100%", "100%", 0).attr({
    stroke: "none"
  });
  Raphael.getColor.reset();
  cwidth = c.getBBox().width;
  cheight = c.getBBox().height;
  window.abs = Math.abs;
  window.acos = Math.acos;
  window.asin = Math.asin;
  window.atan = Math.atan;
  window.ceil = Math.ceil;
  window.cos = Math.cos;
  window.exp = Math.exp;
  window.floor = Math.floor;
  window.log = Math.log;
  window.max = Math.max;
  window.min = Math.min;
  window.pi = Math.PI;
  window.pow = Math.pow;
  window.random = Math.random;
  window.round = Math.round;
  window.sin = Math.sin;
  window.sqrt = Math.sqrt;
  window.tan = Math.tan;
  window.circle = function(x, y, r) {
    return paper.circle(x, y, r);
  };
  window.rect = function(x, y, w, h, r) {
    return paper.rect(x, y, w, h, r);
  };
  window.ellipse = function(x, y, rx, ry) {
    return paper.ellipse(x, y, rx, ry);
  };
  window.image = function(url, x, y, w, h) {
    return paper.image(url, x, y, w, h);
  };
  window.text = function(x, y, str) {
    return paper.text(x, y, str);
  };
  window.path = function(str) {
    return paper.path(str);
  };
  window.getColor = function() {
    return Raphael.getColor();
  };
  window.set = paper.set;
  window.clear = paper.clear;
  window.createAxis = function(width, height, ticwidth) {
    var axis, grid, i, inc, labels, o, ox, tic, xmarks, xtics, ymarks, ytics, _ref, _ref2;
    if (width === "100%") {
      width = cwidth;
    }
    if (height === "100%") {
      height = cheight;
    }
    axis = set();
    grid = set();
    labels = set();
    o = [ticwidth, height - ticwidth];
    ox = [width - ticwidth, ticwidth];
    axis.push(path("M" + o[0] + " " + o[1] + "L" + ox[0] + " " + o[1]));
    axis.push(path("M" + o[0] + " " + o[1] + "L" + o[0] + " " + o[0]));
    tic = function(x, y, w, h) {
      var p1, p2;
      p1 = [x, y];
      p2 = [x - w, y + h];
      return path("M" + p1[0] + " " + p1[1] + "L" + p2[0] + " " + p2[1]);
    };
    xtics = set();
    ytics = set();
    xmarks = Math.ceil(width / ticwidth);
    ymarks = Math.ceil(height / ticwidth);
    for (i = 1; (1 <= xmarks ? i <= xmarks : i >= xmarks); (1 <= xmarks ? i += 1 : i -= 1)) {
      inc = i * ticwidth;
      grid.push(path("M" + inc + " 0L" + inc + " " + height));
    }
    for (i = 1; (1 <= ymarks ? i <= ymarks : i >= ymarks); (1 <= ymarks ? i += 1 : i -= 1)) {
      inc = i * ticwidth;
      grid.push(path("M0 " + inc + "L" + width + " " + inc));
    }
    for (i = 0, _ref = xmarks - 3; (0 <= _ref ? i <= _ref : i >= _ref); (0 <= _ref ? i += 1 : i -= 1)) {
      inc = ticwidth + i * ticwidth;
      if (i % 2 === 1) {
        xtics.push(tic(inc, height - ticwidth, 0, 8));
      } else {
        xtics.push(tic(inc, height - ticwidth, 0, 12));
        labels.push(text(inc, height - 16, inc + ""));
      }
    }
    for (i = 0, _ref2 = ymarks - 4; (0 <= _ref2 ? i <= _ref2 : i >= _ref2); (0 <= _ref2 ? i += 1 : i -= 1)) {
      inc = ticwidth + i * ticwidth;
      if (i % 2 === 1) {
        ytics.push(tic(ticwidth, height - inc, 8, 0));
      } else {
        ytics.push(tic(ticwidth, height - inc, 12, 0));
        labels.push(text(14, height - inc, inc + ""));
      }
    }
    axis.push(xtics);
    axis.push(ytics);
    axis.attr({
      stroke: "#444",
      opacity: 0
    });
    grid.attr({
      stroke: "#272727"
    });
    labels.attr({
      stroke: "#888"
    });
    return {
      axis: axis,
      grid: grid,
      labels: labels
    };
  };
  Raphael.el.anim = function(obj) {
    var duration;
    if (obj.duration !== void 0) {
      duration = obj.duration;
      delete obj.duration;
      return this.animate(obj, duration);
    } else {
      return this.animate(obj);
    }
  };
  attrs = ['cursor', 'cx', 'cy', 'fill', 'font', 'height', 'href', 'opacity', 'path', 'r', 'rotation', 'rx', 'ry', 'scale', 'src', 'stroke', 'target', 'title', 'translation', 'width', 'x', 'y'];
  attrs2 = ['clip-rect', 'fill-opacity', 'font-family', 'font-size', 'font-weight', 'stroke-dasharray', 'stroke-linecap', 'stroke-linejoin', 'stroke-miterlimit', 'stroke-opacity', 'text-anchor'];
  _results = [];
  for (_i = 0, _len = attrs.length; _i < _len; _i++) {
    attr = attrs[_i];
    _results.push((function(attr) {
      return Raphael.el[attr] = function(value) {
        var obj;
        obj = {};
        obj[attr] = value;
        console.log(obj);
        return this.attr(obj);
      };
    })(attr));
  }
  return _results;
};
randomPath = function(length, j, dotsy) {
  var i, random_path, x, y;
  random_path = "";
  x = 10;
  y = 0;
  dotsy[j] = dotsy[j] || [];
  for (i = 0; (0 <= length ? i <= length : i >= length); (0 <= length ? i += 1 : i -= 1)) {
    dotsy[j][i] = round(random() * 200);
    if (i) {
      random_path += "C" + [x + 10, y, (x += 20) - 10, (y = 240 - dotsy[j][i]), x, y];
    } else {
      random_path += "M" + [10, (y = 240 - dotsy[j][i])];
    }
  }
  return random_path;
};